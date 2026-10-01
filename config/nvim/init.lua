vim.pack.add({
	{ src = "https://github.com/scottmckendry/cyberdream.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/creativenull/efmls-configs-nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/theprimeagen/harpoon", version = "harpoon2" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.icons" },
	{ src = "https://github.com/mbbill/undotree" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{
		src = "https://github.com/obsidian-nvim/obsidian.nvim",
		version = vim.version.range("*"),
	},
	{ src = "https://github.com/yousefhadder/markdown-plus.nvim" },
})
local function packadd(name)
	vim.cmd("packadd " .. name)
end

packadd("cyberdream.nvim")
packadd("nvim-treesitter")
packadd("nvim-lspconfig")
packadd("fzf-lua")
packadd("nvim-web-devicons")
packadd("lualine.nvim")
packadd("blink.lib")
packadd("blink.cmp")
packadd("friendly-snippets")
packadd("vim-fugitive")
packadd("gitsigns.nvim")
packadd("efmls-configs-nvim")
packadd("plenary.nvim")
packadd("harpoon")
packadd("oil.nvim")
packadd("mini.icons")
packadd("trouble.nvim")
packadd("snacks.nvim")

require("bduck")
require("colors")
require("treesitter")
require("navigation")
require("statusline")
require("lsp")
require("notes")
require("ui")
