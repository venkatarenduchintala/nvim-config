return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				automatic_enable = false,
				-- skip heavy binary downloads in CI; lazy.nvim plugin code is still validated
				ensure_installed = vim.env.CI and {} or {
					"ansiblels",
					"awk_ls",
					"bashls",
					"clangd",
					"docker_compose_language_service",
					"dockerls",
					"dotls",
					"elixirls",
					"eslint",
					"gradle_ls",
					"groovyls",
					"html",
					"jdtls",
					"jqls",
					"jsonls",
					"kotlin_language_server",
					"lua_ls",
					"matlab_ls",
					"perlnavigator",
					"pyright",
					"rust_analyzer",
					"tsp_server",
					"yamlls",
				},
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		"mfussenegger/nvim-lint",
		"rshkarin/mason-nvim-lint",
		config = function()
			require("mason-nvim-lint").setup({
				automatic_installation = not vim.env.CI,
				quiet_mode = false,
				ensure_installed = vim.env.CI and {} or {
					"actionlint",
					"ansible-lint",
					"api-linter",
					"black",
					"cmakelang",
					"csharpier",
					"cpplint",
					"dotenv-linter",
					"elm-formatter",
					"eslint_d",
					"jq",
					"kube-linter",
					"luacheck",
					"markdownlint",
					"markdown-toc",
					"prettier",
					"pylint",
					"xmlformatter",
					"yamlfix",
					"yamlfmt",
					"yamllint",
					"zsh",
				},
				ignore_install = {},
			})
		end,
	},
	{
		"williamboman/mason-nvim-dap.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"mfussenegger/nvim-dap",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = vim.env.CI and {} or {
					"codelldb",
					"javatest",
					"javadbg",
				},
			})
		end,
	},
}
