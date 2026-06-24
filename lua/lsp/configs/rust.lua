return {
	-- rustaceanvim: native LSP API Rust support (replaces archived rust-tools.nvim)
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = {
				tools = {
					hover_actions = { auto_focus = true },
				},
			}
			-- Rust-specific keymaps; global on_attach is wired in lsp/init.lua via LspAttach
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "rust_analyzer" then
						require("which-key").add({
							{ "<leader>dE", "<cmd>RustLsp debuggables<cr>",  desc = "[RUST] Show debuggables", buffer = args.buf },
							{ "<leader>de", "<cmd>RustLsp! debuggables<cr>", desc = "[RUST] Debug last",       buffer = args.buf },
							{ "<leader>dR", "<cmd>RustLsp runnables<cr>",    desc = "[RUST] Show runnables",   buffer = args.buf },
							{ "<leader>dr", "<cmd>RustLsp! runnables<cr>",   desc = "[RUST] Run last",         buffer = args.buf },
						})
					end
				end,
			})
		end,
	},
	-- crates.nvim: Cargo.toml dependency management
	{
		"saecki/crates.nvim",
		enabled = true,
		event = { "BufRead Cargo.toml" },
		tag = "v0.4.0",
		lazy = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("crates").setup({
				src = { cmp = { enabled = true } },
				popup = { border = "rounded" },
			})
		end,
	},
}
