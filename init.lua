vim.cmd([[set mouse=a]])
vim.cmd([[set noswapfile]])
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

local map = vim.keymap.set
vim.g.mapleader = " "
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{
			"vague2k/vague.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd("colorscheme vague")
			end
		},
		{
			"nvim-mini/mini.pick",
			lazy = false,
		},
  	{"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
		{ "https://github.com/neovim/nvim-lspconfig" },
	},
  checker = { enabled = false },
})

require('mini.pick').setup()

map('n', '<leader>f', ":Pick files<CR>")


-- Lookup this for language server names:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
servers = {"gopls", "rust_analyzer", "clangd"}

vim.lsp.enable(servers)

for _, language_server in pairs(servers)
do
	require("lspconfig")[language_server].setup({
		on_attach = function(client, bufnr)
				vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = true,
			convert = function(item)
						return { abbr = item.label:gsub("%b()", "") }
			end,
				})
				vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
			end
	})
end
