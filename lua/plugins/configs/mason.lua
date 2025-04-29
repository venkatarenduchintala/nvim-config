return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          }
        }
      })
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
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
          "pyright",
					"rust_analyzer",
					"tsp_server",
					"yamlls",
				},
				automatic_installation = true,
			})
		end,
	},
  {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-lint",
    "rshkarin/mason-nvim-lint",
    config = function()
      require('mason-nvim-lint').setup({
        -- Whether linters that are set up (via nvim-lint) should be automatically installed if they're not already installed.
        -- It tries to find the specified linters in the mason's registry to proceed with installation.
        -- This setting has no relation with the `ensure_installed` setting.
        ---@type boolean
        automatic_installation = true,

        -- Disables warning notifications about misconfigurations such as invalid linter entries and incorrect plugin load order.
        quiet_mode = false,        

        -- A list of linters to automatically install if they're not already installed. Example: { "eslint_d", "revive" }
        -- This setting has no relation with the `automatic_installation` setting.
        -- Names of linters should be taken from the mason's registry.
        ---@type string[]
        ensure_installed = {
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

        -- Avoid trying to install an unknown linter
        ignore_install = {},

      })
    end,
  },
	{
		"williamboman/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = {
					"codelldb",
					"javatest",
					"javadbg",
				},
			})
		end,
	},
}
