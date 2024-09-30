-- file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'mustache/vim-mustache-handlebars'

  use ('junegunn/fzf')
  -- THEMES
  use('mellow-theme/mellow.nvim')
  use('aktersnurra/no-clown-fiesta.nvim')
  use('rose-pine/neovim')
  use("savq/melange-nvim")
  use('lourenci/github-colors')
  use('fenetikm/falcon')
  use('rebelot/kanagawa.nvim')
  use('EdenEast/nightfox.nvim')

  use("folke/zen-mode.nvim")

  use({
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup {
              icons = false,
          }
      end
  })

  use({
      "Pocco81/auto-save.nvim",
      config = function()
          require("auto-save").setup {
          }
      end,
  })

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/playground')
  use('ThePrimeagen/harpoon')
  --use('github/copilot.vim')
  use('vim-test/vim-test')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  use({
      'VonHeikemen/lsp-zero.nvim',
      requires = {
          -- LSP Support
          {'neovim/nvim-lspconfig'},
          {'williamboman/mason.nvim'},
          {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

          -- Snippets
          {'L3MON4D3/LuaSnip'},
          {'rafamadriz/friendly-snippets'},
        }
      })

  use({
      'wojciech-kulik/xcodebuild.nvim',
      requires = {
          {"nvim-telescope/telescope.nvim"},
          {"MunifTanjim/nui.nvim"},
      }
  })

end)
