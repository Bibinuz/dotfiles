-- =========================
-- PLUGINS
-- =========================

vim.pack.add({
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://www.github.com/nvim-tree/nvim-tree.lua",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	-- Language Server Protocols
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/mbbill/undotree",
	"https://github.com/j-hui/fidget.nvim",
})

-- =========================
-- PLUGINS CONFIGS
-- =========================

require("plugins.treesitter")
require("plugins.nvim-tree")
require("plugins.fzf")
require("plugins.mini")
require("plugins.lsp")
require("plugins.undotree")
require("plugins.fidget")
