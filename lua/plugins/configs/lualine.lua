return {
    -- Status bar
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = true,
                -- "auto" derives the statusline palette from whatever colorscheme
                -- is active, so any theme in lua/themes/ works without a matching
                -- lualine theme name.
                theme = "auto",
                disabled_filetypes = {},
                always_divide_middle = true,
                globalstatus = true,
            },
            sections = {
                lualine_c = {
                    "aerial",
                },
            },
        })
    end,
}
