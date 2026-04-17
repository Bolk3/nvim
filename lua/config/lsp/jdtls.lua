local function get_jdtls()
    local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
    local jdtls_path = mason_path .. "/jdtls"
    local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    local os_config = "linux"

    return {
        launcher = launcher,
        config_dir = jdtls_path .. "/config_" .. os_config,
    }
end

local function get_workspace()
    local home = os.getenv("HOME")
    local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    return home .. "/.local/share/nvim/jdtls-workspaces/" .. project
end

local function on_attach(_, bufnr)
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()

    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "<leader>jo", require("jdtls").organize_imports, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
    vim.keymap.set("n", "<leader>jv", require("jdtls").extract_variable, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
    vim.keymap.set("n", "<leader>jc", require("jdtls").extract_constant, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
    vim.keymap.set("v", "<leader>jm", function() require("jdtls").extract_method(true) end, vim.tbl_extend("force", opts, { desc = "Extract method" }))
end

local function start_jdtls()
    local jdtls = get_jdtls()

    local config = {
        cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx4g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens", "java.base/java.util=ALL-UNNAMED",
            "--add-opens", "java.base/java.lang=ALL-UNNAMED",
            "-jar", jdtls.launcher,
            "-configuration", jdtls.config_dir,
            "-data", get_workspace(),
        },
        root_dir = vim.fs.root(0, {
            "pom.xml",
            "build.gradle",
            "build.gradle.kts",
            ".git",
            "mvnw",
            "gradlew",
        }),
        settings = {
            java = {
                eclipse = { downloadSources = true },
                maven = { downloadSources = true },
                implementationsCodeLens = { enabled = true },
                referencesCodeLens = { enabled = true },
                inlayHints = { parameterNames = { enabled = "all" } },
                signatureHelp = { enabled = true },
                contentProvider = { preferred = "fernflower" },
                completion = {
                    favoriteStaticMembers = {
                        "org.junit.Assert.*",
                        "org.junit.Assume.*",
                        "org.junit.jupiter.api.Assertions.*",
                        "org.junit.jupiter.api.Assumptions.*",
                        "org.junit.jupiter.api.DynamicContainer.*",
                        "org.junit.jupiter.api.DynamicTest.*",
                    },
                    importOrder = { "java", "javax", "com", "org" },
                },
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticStarThreshold = 9999,
                    },
                },
                codeGeneration = {
                    toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
                    useBlocks = true,
                },
            },
        },
        on_attach = on_attach,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
    }

    require("jdtls").start_or_attach(config)
end

-- Démarre jdtls à chaque fois qu'on ouvre un fichier Java
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = start_jdtls,
})
