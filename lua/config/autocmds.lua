local neocolumn_group = vim.api.nvim_create_augroup("NeoColumnToggle", {clear = true})
local lang_group = vim.api.nvim_create_augroup("LanguageColumns", { clear = true })
local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

local lang_settings = {
    c          = { "80" },           -- Strict (Standard Kernel/Embedded)
    cpp        = { "80", "100" },
    java       = { "100", "120" },
    gitcommit  = { "50", "72" },    -- 50 pour le titre, 72 pour le corps
    typescript = { "80", "100" },
    html       = { "100", "120" },
    css        = { "80", "100" },
    lua        = { "80", "120" },
    python     = { "88", "110" },    -- 88 (Black) et une marge de sécurité
}

vim.api.nvim_create_autocmd({ "BufEnter", "FileType"}, {
	group = neocolumn_group,
	pattern = "*",
	callback = function()
		local dashboard_types = { "alpha", "dashboard", "starter", "NvimTree" }

		-- Vérification si on est sur un dashboard
		local is_dashboard = vim.tbl_contains(dashboard_types, vim.bo.filetype)

		-- On utilise pcall pour exécuter la commande sans erreur si le plugin manque
		if is_dashboard then
			pcall(vim.cmd, "NeoColumnOff")
		else
			pcall(vim.cmd, "NeoColumnOn")
		end
	end,
})

for ft, columns in pairs(lang_settings) do
    vim.api.nvim_create_autocmd("FileType", {
        group = lang_group,
        pattern = ft,
        callback = function()
            vim.opt_local.colorcolumn = table.concat(columns, ",")
        end,
    })
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    callback = function(ev)
        local opts = { buffer = ev.buf, silent= true }

        opts.desc = "Show LSP references"
        vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definition"
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        opts.desc = "Show LSP implementation"
        vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        vim.keymap.set("n", "gt", "<cmd>Telscope lsp_type_definitions<CR>", opts)

        opts.desc = "Smart rename"
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show documentation for what is under"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
    end,
})
