call plug#begin()
  Plug 'editorconfig/editorconfig-vim'
  Plug 'junegunn/fzf', {'do': { -> fzf#install()}}
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neovim/nvim-lspconfig'
  Plug 'p00f/clangd_extensions.nvim'
  Plug 'vim-airline/vim-airline'
call plug#end()

syntax on

" Use this setting with `gq` to wrap text.
" Disabled because it always auto-wraps.
set textwidth=0

" Quick map for escaping insert mode.
inoremap <C-k> <Esc>
noremap <C-k> <Esc>

" Disable automatic wrapping. This doesn't work.
set formatoptions-=tc

" trigger `autoread` when files changes on disk
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" notification after file change
autocmd FileChangedShellPost *
\ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Touch a central file to trigger watching `enter` instances.
autocmd BufWritePost * silent! !echo $(date +\%s) > /Users/rik/git/last_nvim_write.txt

let g:slime_target="x11"

let g:coc_global_extensions = [
    \'coc-clangd',
    \'coc-pyright',
    \'coc-rust-analyzer',
    \]

set spelllang=en_us

" To see trailing spaces.
set list

set tabstop=4
set shiftwidth=4 " Related to normal mode indentation commands.
set expandtab " Enforce insert spaces and not tabs.

set noinsertmode " Disable insert mode.

" This appears to have stopped working on newer NeoVim versions?
autocmd BufRead,BufNewFile *.jl set filetype=julia
autocmd FileType julia setlocal ts=4 sts=4 sw=4 expandtab
" To ensure that indentation is the same for Julia and Franklin Markdown.
autocmd FileType markdown setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType cpp setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufRead,BufNewFile *.td set filetype=TableGen
autocmd FileType TableGen setlocal ts=2 sts=2 sw=2 expandtab
" Same as in llvm-project/mlir/utils/vim/ftdetect/mlir.vim
" For syntax highlighting, see the mlir.vim file.
autocmd BufRead,BufNewFile *.mlir set filetype=mlir
autocmd FileType mlir setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType sh setlocal ts=2 sts=2 sw=2 expandtab

set smartcase " Ignore case if search pattern is lower case.

" Shortcuts, see https://vim.fandom.com/wiki/Alternative_tab_navigation
" Chosen such that they do not conflict with Zellij.
nmap <C-e> :wa<CR>
nmap <C-w> :bd<CR> " Unload buffer d(efault).
nmap <C-t> :FZF<CR>
imap <C-e> <ESC>:wa<CR>
imap <C-w> <ESC>:bd<CR>
imap <C-t> <Esc>:FZF<CR>
nnoremap F :bprevious<CR>
nnoremap J :bnext<CR>

" This unsets the 'last search pattern' register by hitting return
nnoremap <CR> :noh<CR><CR>

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Straight tabs
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" FZF include hidden
let $FZF_DEFAULT_COMMAND = 'rg -l ""'

" 
" BEGIN COC.NVIM CONFIGURATION
" 
" Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
set shell=/bin/sh

" Without this TextEdit might fail, and we cannot switch buffers without save.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
let col = col('.') - 1
return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
if (index(['vim','help'], &filetype) >= 0)
  execute 'h '.expand('<cword>')
else
  call CocAction('doHover')
endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
autocmd!
" Update signature help on jump placeholder
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
" Removed since it was incompatible with Nix syntax.

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Force disable automatic indentation.
:setl inde=

lua << EOF
  local lspconfig = require'lspconfig'

  local function on_attach(client, bufnr)
    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()
  end

  lspconfig.clangd.setup({
    on_attach = on_attach
  })
EOF

