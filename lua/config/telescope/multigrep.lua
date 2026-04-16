local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local conf = require "telescope.config".values

local M = {}

local live_multigrep = function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.uv.cwd()

    -- CORRECTION 1: On assigne le finder à une variable
    local finder = finders.new_async_job {
        command_generator = function(prompt)
            if not prompt or prompt == "" then
                return nil
            end

            local pieces = vim.split(prompt, "  ") -- split sur deux espaces
            local args = { "rg" }

            if pieces[1] then
                table.insert(args, "-e")
                table.insert(args, pieces[1])
            end

            if pieces[2] then
                table.insert(args, "-g")
                table.insert(args, pieces[2])
            end

            -- CORRECTION 2: Utilisation de vim.iter ou flattened table pour la clarté
            return vim.iter({
		    args,
		    { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
	    }):flatten():totable()
        end,
        entry_maker = make_entry.gen_from_vimgrep(opts),
        cwd = opts.cwd,
    }
    
    pickers.new(opts, {
        debounce = 100,
        prompt_title = "Multi Grep",
        finder = finder, -- Maintenant 'finder' existe bien
        previewer = conf.grep_previewer(opts),
        sorter = require("telescope.sorters").empty()
    }):find()
end

M.setup = function()
    -- On expose la fonction pour pouvoir la mapper à une touche
    live_multigrep()
end

return M
