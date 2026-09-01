vim.pack.add{
    { src = 'https://github.com/scottmckendry/cyberdream.nvim'}, 
    { src ='https://github.com/nvim-treesitter/nvim-treesitter'},
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/ibhagwan/fzf-lua' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
    { src = 'https://github.com/saghen/blink.lib' },
    { src = 'https://github.com/saghen/blink.cmp' },
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
    { src = 'https://github.com/tpope/vim-fugitive' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
}
local function packadd(name)
    vim.cmd("packadd ".. name)
end

packadd("cyberdream.nvim")
packadd("nvim-treesitter")
packadd("nvim-lspconfig")
packadd("fzf-lua")
packadd("nvim-web-devicons")
packadd("lualine.nvim")


require("bduck")
require("colors")
require("treesitter")
require("navigation")
require("statusline")
require("lsp")
require("completion")
