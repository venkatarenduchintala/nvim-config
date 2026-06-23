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
				-- Auto-enable all installed servers; jdtls has its own startup lifecycle
				automatic_enable = {
					exclude = { "jdtls" },
				},
				-- skip heavy binary downloads in CI; lazy.nvim plugin code is still validated
				ensure_installed = vim.env.CI and {} or {
					-- SRE
					"gopls",
					"terraformls",
					"helm_ls",
					"ansiblels",
					"jsonnet_ls",
					"bashls",
					"dockerls",
					"docker_compose_language_service",
					"yamlls",
					-- General dev
					"lua_ls",
					"marksman",
					"pyright",
					"rust_analyzer",
					"clangd",
					"eslint",
					"html",
					"cssls",
					"jsonls",
					-- Java (enabled separately via lsp/configs/java.lua)
					"jdtls",
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
					"tflint",
					"shellcheck",
					"shfmt",
					"hadolint",
					"ruff",
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

			-- Wire up nvim-lint: which linters run per filetype and when
			local lint = require("lint")
			lint.linters_by_ft = {
				yaml       = { "yamllint" },
				sh         = { "shellcheck" },
				bash       = { "shellcheck" },
				dockerfile = { "hadolint" },
				python     = { "ruff" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
				pattern = { "*.yaml", "*.yml", "*.sh", "Dockerfile", "dockerfile", "*.py" },
				callback = function()
					lint.try_lint()
				end,
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
					"delve",
					"codelldb",
					"javatest",
					"javadbg",
				},
			})
		end,
	},
}
