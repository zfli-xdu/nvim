local fn = vim.fn

-- Automatically install packer if packer.nvim does not exist
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that automatically run :PackerCompile whenever plugins.lua is updated
vim.cmd([[
	augroup packer_user_config
	autocmd!
	autocmd BufWritePost plugins.lua source <afile> | PackerSync
	augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	use({ "wbthomason/packer.nvim" }) -- Have packer manage itself
	use({ "nvim-lua/popup.nvim" })
	use({ "nvim-lua/plenary.nvim" }) -- Useful lua functions used by lots of plugins
	use({ "windwp/nvim-autopairs" }) -- Autopairs, integrates with both cmp and treesitter
	use({ "numToStr/Comment.nvim" }) -- Support Line-comment, Block-comment and other commenting methods
	use({ "akinsho/bufferline.nvim", tag = "*" }) -- A snazzy buffer line (with tabpage integration)
	use({ "nvim-lualine/lualine.nvim" }) -- A blazing fast and easy to configure statusline
    use({ "akinsho/toggleterm.nvim", tag = "*" }) -- persist and toggle multiple terminals during an editing session

	-- colorscheme --
	use ({ 'Mofiqul/vscode.nvim' }) -- VSCode Dark and Light theme
    -- use({ "tomasiser/vim-code-dark" }) -- VSCode Dark+ theme
	-- use({ "sainnhe/gruvbox-material" }) -- gruvbox theme

	-- cmp --
	use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "hrsh7th/cmp-cmdline" }) -- cmdline completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })
    use { "zbirenbaum/copilot.lua" } -- a pure lua replacement for github/copilot.vim 
    use {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function ()
            require("copilot_cmp").setup()
        end
    }

	-- snippets --
	use({ "L3MON4D3/LuaSnip" }) -- snippet engine
	use({ "rafamadriz/friendly-snippets" }) -- a bunch of snippets to use

	-- LSP --
	use({
		"neovim/nvim-lspconfig", -- enable LSP
		"williamboman/mason.nvim", -- simple to use language server installer
		"williamboman/mason-lspconfig.nvim",
		"jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
	})
	--use { "RRethy/vim-illuminate" }

	-- telescope --
	use({ "nvim-telescope/telescope.nvim" })
	use({ "nvim-telescope/telescope-media-files.nvim" })

	-- treesitter --
	use({
		"nvim-treesitter/nvim-treesitter", -- syntex highlighting
		run = ":TSUpdate",
	})
	use({ "p00f/nvim-ts-rainbow" }) -- rainbow pairs
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

	-- NvimTree --
	use({
		"nvim-tree/nvim-tree.lua",
		"nvim-tree/nvim-web-devicons",
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
