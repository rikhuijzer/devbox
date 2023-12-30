call plug#begin()
  Plug 'editorconfig/editorconfig-vim'
  Plug 'junegunn/fzf', {'do': { -> fzf#install()}}
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neovim/nvim-lspconfig'
  Plug 'p00f/clangd_extensions.nvim'
  Plug 'vim-airline/vim-airline'
call plug#end()
