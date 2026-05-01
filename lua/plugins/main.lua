local api = vim.api
local env = require("config.env")
env.load()
-- sudo pacman -S lua51 # for image.nvim
 
-- ┌─────────────────────────────────────────────┐
-- │  Configuration – override from another file │
-- │  e.g.  require("plugins.profile")           │
-- │        local M = require("profile_config")  │
-- └─────────────────────────────────────────────┘
local M = {
  -- GitHub
  user              = env.get("GITHUB_USER", "Bolk3"),
  github_token      = env.get("GITHUB_TOKEN"),
  pinned_repos_max  = tonumber(env.get("GITHUB_PINNED_REPOS_MAX", "2")),
  repo_desc_max_len = tonumber(env.get("GITHUB_REPO_DESC_MAX_LEN", "40")),
  -- Cache
  cache_enabled     = env.get("CACHE_ENABLED", "true") == "true",
  cache_path        = vim.fn.stdpath("cache") .. "/profile_pinned_repos.json",
  cache_ttl_seconds = tonumber(env.get("CACHE_TTL_SECONDS", "86400")),
  -- Git contributions graph
  git_contrib = {
      start_week  = tonumber(env.get("GIT_CONTRIB_START_WEEK", "1")),
      end_week    = tonumber(env.get("GIT_CONTRIB_END_WEEK", "53")),
      empty_char  = env.get("GIT_CONTRIB_EMPTY_CHAR", " "),
      full_char   = { "󰧞", "", "●", "●", "" },
      fake        = nil,
  },
  -- Avatar
  force_blank_avatar = env.get("FORCE_BLANK_AVATAR", "false") == "true",
  -- UI – cursor start position in the profile buffer
  cursor_pos         = {
      tonumber(env.get("CURSOR_POS_ROW", "17")),
      tonumber(env.get("CURSOR_POS_COL", "46")),
  },
  -- Highlight groups used in the layout
   hl = {
    header      = env.get("HL_HEADER", "function"),
    git_url     = env.get("HL_GIT_URL", "ProfileRed"),
    by_line     = env.get("HL_BY_LINE", "ProfileBlue"),
    card_border = env.get("HL_CARD_BORDER", "ProfileYellow"),
    card_text   = env.get("HL_CARD_TEXT", "ProfileYellow"),
  },
  -- Keymaps
  open_profile_key = env.get("OPEN_PROFILE_KEY", "<leader>p"),
  buffer_keys = {
    n = {
      ["r"]          = "<cmd>FzfLua oldfiles<cr>",
      ["f"]          = "<cmd>FzfLua files<cr>",
      ["d"]          = "<cmd>FzfLua files cwd=$HOME/.config/nvim<cr>",
      ["/"]          = "<cmd>FzfLua live_grep<cr>",
      ["n"]          = "<cmd>enew<cr>",
      ["<tab><tab>"] = "<cmd>enew<cr>",
      ["l"]          = "<cmd>Lazy<cr>",
    },
  },
  disabled_keys = { "h", "j", "k", "<Left>", "<Right>", "<Up>", "<Down>", "<C-f>", "e", "w" },
 
  -- ASCII header lines
  header = {
    [[/**                                                         ]],
    [[ *     _        _______  _______          _________ _______ ]],
    [[ *    ( (    /|(  ____ \(  ___  )|\     /|\__   __/(       )]],
    [[ *    |  \  ( || (    \/| (   ) || )   ( |   ) (   | () () |]],
    [[ *    |   \ | || (__    | |   | || |   | |   | |   | || || |]],
    [[ *    | (\ \) ||  __)   | |   | |( (   ) )   | |   | |(_)| |]],
    [[ *    | | \   || (      | |   | | \ \_/ /    | |   | |   | |]],
    [[ *    | )  \  || (____/\| (___) |  \   /  ___) (___| )   ( |]],
    [[ *    |/    )_)(_______/(_______)   \_/   \_______/|/     \|]],
    [[ *                                                          ]],
    [[ */                                                         ]],
  },
}
 
-- ─────────────────────────────────────────────
-- Cache helpers
-- ─────────────────────────────────────────────
 
--- Read the on-disk cache. Returns the decoded table or nil.
local function cache_read()
  if not M.cache_enabled then return nil end
  local f = io.open(M.cache_path, "r")
  if not f then return nil end
  local raw = f:read("*a")
  f:close()
  local ok, data = pcall(vim.json.decode, raw)
  if not ok or type(data) ~= "table" then return nil end
  -- TTL check
  if (os.time() - (data.timestamp or 0)) > M.cache_ttl_seconds then return nil end
  return data.repos
end
 
--- Write repos table to the on-disk cache.
local function cache_write(repos)
  if not M.cache_enabled then return end
  local payload = vim.json.encode({ timestamp = os.time(), repos = repos })
  local f = io.open(M.cache_path, "w")
  if not f then return end
  f:write(payload)
  f:close()
end
 
-- ─────────────────────────────────────────────
-- GitHub GraphQL fetch
-- ─────────────────────────────────────────────
 
--- Fetch pinned repos from GitHub. Returns a list of {title, description}.
local function fetch_pinned_repos()
  local token = M.github_token
  if not token or token == "" then return nil end
 
  local query = string.format(
    '{"query":"{ user(login: \\"%s\\") { pinnedItems(first: 6, types: REPOSITORY) { nodes { ... on Repository { name description } } } } }"}',
    M.user
  )
 
  local cmd = string.format(
    'curl -s -X POST -H "Authorization: Bearer %s" -H "Content-Type: application/json" -d \'%s\' "https://api.github.com/graphql"',
    token, query
  )
 
  local handle = io.popen(cmd)
  if not handle then return nil end
  local result = handle:read("*a")
  handle:close()
 
  local ok, data = pcall(vim.json.decode, result)
  if not ok or not (data and data.data and data.data.user) then return nil end
 
  local repos = {}
  local nodes = data.data.user.pinnedItems.nodes
  for i, repo in ipairs(nodes) do
    if i > M.pinned_repos_max then break end
    local desc = tostring(repo.description or "No description")
    if #desc > M.repo_desc_max_len then
      desc = desc:sub(1, M.repo_desc_max_len) .. "..."
    end
    table.insert(repos, { title = tostring(repo.name or "unknown"), description = desc })
  end
  return repos
end
 
--- Return pinned repos, using cache when available.
local function get_pinned_repos()
  local cached = cache_read()
  if cached then return cached end
 
  local repos = fetch_pinned_repos()
  if repos and #repos > 0 then
    cache_write(repos)
    return repos
  end
  return { { title = "No pinned repos found", description = "" } }
end
 
-- ─────────────────────────────────────────────
-- Plugin spec
-- ─────────────────────────────────────────────
 
return {
  {
    "Kurama622/profile.nvim",
    dependencies = { "ibhagwan/fzf-lua" },
    config = function()
      local comp = require("profile.components")
 
      require("profile").setup({
        avatar_opts = { force_blank = M.force_blank_avatar },
        user         = M.user,
        github_token = M.github_token,
        git_contributions = {
          start_week = M.git_contrib.start_week,
          end_week   = M.git_contrib.end_week,
          empty_char = M.git_contrib.empty_char,
          full_char  = M.git_contrib.full_char,
          fake_contributions = M.git_contrib.fake,
        },
        hide = { statusline = true, tabline = true },
        disable_keys = M.disabled_keys,
        cursor_pos   = M.cursor_pos,
 
        format = function()
          local repos_items = get_pinned_repos()
 
          -- Header
          for _, line in ipairs(M.header) do
            comp:text_component_render({
              comp:text_component(line, "center", M.hl.header),
            })
          end
 
          -- Git URL + author line
          comp:text_component_render({
            comp:text_component("git@github.com:" .. M.user, "center", M.hl.git_url),
            comp:text_component("──── By " .. M.user, "right", M.hl.by_line),
          })
 
          comp:separator_render()
 
          -- Pinned repos card
          comp:card_component_render({
            type    = "table",
            content = function() return repos_items end,
            hl      = { border = M.hl.card_border, text = M.hl.card_text },
          })
 
          comp:separator_render()
          comp:git_contributions_render("String")
        end,
      })
 
      -- Global keymap to open profile
      api.nvim_set_keymap("n", M.open_profile_key, "<cmd>Profile<cr>", { silent = true })
 
      -- Buffer-local keymaps + cursor tweak when entering the profile buffer
      api.nvim_create_autocmd("FileType", {
        pattern  = "profile",
        callback = function()
          vim.opt_local.guicursor = "a:Cursor/lCursor"
          vim.api.nvim_set_hl(0, "Cursor", { blend = 100 })
          vim.opt_local.cursorline = false
 
          for mode, mapping in pairs(M.buffer_keys) do
            for key, cmd in pairs(mapping) do
              api.nvim_buf_set_keymap(0, mode, key, cmd, { noremap = true, silent = true })
            end
          end
        end,
      })
 
      -- Restore cursor when leaving the profile buffer
      api.nvim_create_autocmd("BufLeave", {
        pattern  = "*",
        callback = function()
          if vim.bo.filetype == "profile" then
            vim.api.nvim_set_hl(0, "Cursor", { blend = 0 })
            vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
          end
        end,
      })
    end,
  },
}

