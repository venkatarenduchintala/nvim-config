return {

  {
    "mfussenegger/nvim-dap-python",
    ft = { "py" },
    config = function()
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
    end,
  },
  {
    'geg2102/nvim-jupyter-client',
    config = function()
      require('nvim-jupyter-client').setup({
        template = {
          cells = {
            {
              cell_type = "code",
              execution_count = nil,
              metadata = {},
              outputs = {},
              source = {"# Custom template cell\n"}
            },
          },
          metadata = {
            kernelspec = {
              display_name = "Python 3",
              language = "python",
              name = "python3",
            },
          },
          nbformat = 4,
          nbformat_minor = 5,
        },
        cell_highlight_group = "CurSearch", --whatever you want here
        -- If custom highlight group then set these manually
        highlights = {
          cell_title = {
              fg = "#ffffff",
              bg = "#000000",
          },
        },
        require("which-key").add({
          mode = {"n"},
          -- Add Cells
          {"<leader>ja", "<cmd>JupyterAddCellBelow<cr>", desc = "[JUPYTER CLIENT] Add Jupyter cell below" },
          {"<leader>jA", "<cmd>JupyterAddCellAbove<cr>", desc = "[JUPYTER CLIENT] Add Jupyter cell above" },
          
          -- Cell Operations
          {"<leader>jd", "<cmd>JupyterRemoveCell<cr>", desc = "Remove current Jupyter cell" },
          {"<leader>jm", "<cmd>JupyterMergeCellAbove<cr>", desc = "Merge with cell above" },
          {"<leader>jM", "<cmd>JupyterMergeCellBelow<cr>", desc = "Merge with cell below" },
          {"<leader>jt", "<cmd>JupyterConvertCellType<cr>", desc = "Convert cell type (code/markdown)" },
          {"<leader>jm", "<cmd>JupyterMergeVisual<cr>", desc = "Merge selected cells" },
          {"<leader>jD", "<cmd>JupyterDeleteCell<cr>", desc = "Delete cell under cursor and store in register" },
        })
      })
    end,
  },
  {
    "geg2102/nvim-python-repl",
    dependencies = "nvim-treesitter",
    ft = {"python", "lua", "scala"},
    config = function()
      require("nvim-python-repl").setup({
        execute_on_send = false,
        vsplit = false,
        spawn_command = {
          python = "ipython", 
          scala = "sbt console",
          lua = "ilua",
        },
        require("which-key").add({
          mode = {"n"}, 
          { "<leader>js", function() require('nvim-python-repl').send_statement_definition() end, desc = "[JUPYTER] Send semantic unit to REPL" },
          { "<leader>jS", function() require('nvim-python-repl').send_visual_to_repl() end, desc = "[JUPYTER] Send visual selection to REPL" },
          { "<leader>j", function() require('nvim-python-repl').send_buffer_to_repl() end, desc = "[JUPYTER] Send entire buffer to REPL" },
          { "<leader>je", function() require('nvim-python-repl').toggle_execute() end, desc = "[JUPYTER] Automatically execute command in REPL after sent" },
          { "<leader>jv", function() require('nvim-python-repl').toggle_vertical() end, desc = "[JUPYTER] Create REPL in vertical or horizontal split" },
          { "<leader>jo", function() require('nvim-python-repl').open_repl() end, desc = "[JUPYTER] Opens the REPL in a window split" },
          { "<leader>jc", function() require('nvim-python-repl').send_current_cell_to_repl() end, desc = "[JUPYTER] Sends the cell under cursor to repl" },
        }),
      })
    end,
  },
}
