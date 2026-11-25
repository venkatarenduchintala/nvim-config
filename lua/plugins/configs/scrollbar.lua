return {
    -- Scroll bar
    "petertriho/nvim-scrollbar",
    config = function()
        require("scrollbar").setup({
            scrollbar = {
                thumb = {
                    highlight = { bg = require("theme").colors.red },
                },
            },
        })
    end,
}
