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

      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      lspconfig.pyright.setup({})
      lspconfig.clangd.setup({})
      lspconfig.bashls.setup({})
      lspconfig.html.setup({})
      lspconfig.cssls.setup({})
    end,
  },
}