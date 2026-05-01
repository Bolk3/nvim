local M = {}

-- Charge le .env et expose les variables
function M.load()
  local env_path = vim.fn.stdpath("config") .. "/.env"
  local f = io.open(env_path, "r")
  if not f then return end

  for line in f:lines() do
    -- Ignore commentaires et lignes vides
    if not line:match("^%s*#") and line:match("=") then
      local key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
      if key and value then
        -- Retire les guillemets éventuels
        value = value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
        vim.env[key] = value
      end
    end
  end

  f:close()
end

-- Récupère une variable (avec valeur par défaut optionnelle)
function M.get(key, default)
  return vim.env[key] or default
end

return M
