return {
  {
    "catppuccin/nvim",
    name = "catppuccin-nvim",
    priority = 100000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}

