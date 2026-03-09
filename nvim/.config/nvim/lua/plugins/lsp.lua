return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "clangd",
          "bashls",
          "html",
	  "cssls",
        },
      })


      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      vim.lsp.config('cssls', {


      })
      vim.lsp.enable('pyright')
      vim.lsp.enable('clangd')
      vim.lsp.enable('bashls')
      vim.lsp.enable('html')
      vim.lsp.enable('cssls')

    end,
  },
}
