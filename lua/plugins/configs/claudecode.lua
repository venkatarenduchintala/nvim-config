return {
  -- Claude Code integration via the same WebSocket/MCP protocol as the VS Code extension.
  -- Opens claude CLI in a native terminal split; tracks your active buffer and selection
  -- so Claude has context without you having to paste anything.
  {
    "coder/claudecode.nvim",
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSend",
      "ClaudeCodeAdd",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeSelectModel",
      "ClaudeCodeStatus",
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "[AI] Toggle Claude Code" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "[AI] Focus Claude Code" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v", desc = "[AI] Send selection" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "[AI] Add buffer to context" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "[AI] Accept diff" },
      { "<leader>aD", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "[AI] Deny diff" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "[AI] Select model" },
      -- Add file to Claude context from file explorers
      { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>",
        ft = { "neo-tree", "NvimTree", "oil", "netrw" },
        desc = "[AI] Add file to context" },
    },
    opts = {
      terminal = {
        provider = "native",
        split_side = "right",
        split_width_percentage = 0.38,
        auto_close = true,
        auto_insert = true,
      },
      track_selection = true,
      diff_opts = {
        layout = "vertical",
        auto_resize_terminal = true,
      },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)
      require("which-key").add({
        { "<leader>a", group = "AI / Claude Code" },
      })
    end,
  },

  -- LSP completions inside Claude Code's Ctrl+G compose buffers:
  -- slash commands (/compact, /clear …), @file references, and installed skills.
  {
    "kezhenxu94/nvim-claude-lsp",
    ft = { "markdown", "text" },
    opts = {},
  },
}
