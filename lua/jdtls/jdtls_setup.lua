local M = {}

function M:setup()
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = "/home/bolk3/Documents/developpement/jdtls_data/" .. project_name
	local config = {
		cmd = {
			"/usr/sbin/java",

			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xmx1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.utils=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",

			"-jar",
			"/home/bolk3/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.100.v20251111-0406.jar",

			"-configuration",
			"/home/bolk3/.local/share/nvim/mason/packages/jdtls/config_linux",

			"-data",
			workspace_dir
		},
		init_options = {
			bundles = {},
		},
	}
	require("jdtls").start_or_attach(config)
end

return M
