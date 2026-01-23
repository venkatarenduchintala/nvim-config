local capabilities = require("lsp.handlers").capabilities

local ok, lazy = pcall(require, "lazy")
if ok then
	lazy.load({ plugins = { "nvim-lspconfig" } })
end

local function config(name, cfg)
	vim.lsp.config(name, cfg or {})
end

-- Python
config("pyright", {
	capabilities = capabilities,
	filetypes = { "python" },
})

-- LUA
config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Rust
config("rust_analyzer", {
	on_attach = function(client, bufnr)
		require("lsp.handlers").on_attach(client, bufnr)
		-- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end,
	-- capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = true,
			},
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			procMacro = {
				enable = true,
			},
		},
	},
})

-- Clangd (C++)
config("clangd", {
	capabilities = capabilities,
})

-- Bash
config("bashls", {
	capabilities = capabilities,
})

-- Javascript/Typescript
config("eslint", {
	capabilities = capabilities,
	settings = {
		packageManager = "npm",
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end,
})

-- HTML
config("html", {
	capabilities = capabilities,
})

-- CSS
config("cssls", {
	capabilities = capabilities,
})

-- Dockerfile
config("dockerls", {
	capabilities = capabilities,
})

-- Docker compose
config("docker_compose_language_service", {
	capabilities = capabilities,
})

-- XML
config("lemminx", {
	capabilities = capabilities,
})

-- VUE
config("vuels", {
	capabilities = capabilities,
})

-- YAMLs
config("yamlls", {})

-- CMake Language Server
config("cmake", {})

-- Elixir Language Server
config("elixirls", {
	capabilities = capabilities,
})

-- Erlang Language Server
-- config("erlangls", {
-- 	capabilities = capabilities,
-- })

-- Go Language Server
config("gopls", {
	capabilities = capabilities,
})

-- Gradle Language Server
config("gradle_ls", {
	capabilities = capabilities,
})

-- -- Groovy Language Server
config("groovyls", {
	capabilities = capabilities,
})

-- Helm Language Server
-- config("helm_ls", {
-- 	capabilities = capabilities,
-- })

-- Json Language Server
config("jsonls", {
	capabilities = capabilities,
})

-- Kotlin LS
config("kotlin_language_server", {
	capabilities = capabilities,
})

-- Make Language Server
config("autotools_ls", {
	capabilities = capabilities,
})

-- Powershell Language Server
config("powershell_es", {
	capabilities = capabilities,
})

-- SQL Language Server
config("sqlls", {
	capabilities = capabilities,
})

-- Terraform Language Server
config("terraformls", {
	capabilities = capabilities,
})

vim.lsp.enable({
	"pyright",
	"rust_analyzer",
	"bashls",
	"eslint",
	"html",
	"cssls",
	"dockerls",
	"docker_compose_language_service",
	"lemminx",
	"cmake",
})
