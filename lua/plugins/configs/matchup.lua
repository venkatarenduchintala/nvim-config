return {
  "andymass/vim-matchup",
  config = function()
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
    -- disable matchup's treesitter engine for markdown (same nvim 0.12 incompatibility)
    vim.g.matchup_treesitter_disabled = { "markdown" }
  end,
}
