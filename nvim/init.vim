unlet! skip_defaults_vim

let mapleader=" "

" Basics
set nocompatible
set tabstop=8 softtabstop=0 expandtab shiftwidth=4
set smarttab autoindent smartindent cindent
set encoding=utf-8
set number relativenumber

" Enable clipboard support
set clipboard+=unnamedplus

" Disable search highlighting
set nohlsearch

" Enable mouse support in Normal Visual Insert Command-line modes
set mouse=a

" No copy when changing
nnoremap c "_c

" Enable loading plugin files for filetype detection
filetype plugin indent on
syntax on

" Fuzzy find
set path+=**

" .viminfo path
if !has('nvim')
    set viminfo+=n~/history/viminfo
endif

" Reload config
autocmd! bufwritepost init.vim source %
command! ReloadConfig :so $HOME/.config/nvim/init.vim

" Disable automatic comments on newlines
" autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Autocompletition
set wildmode=longest,list,full

""
"" Basic keymaps
""

map <leader>q :q<CR>
map <leader>wq :wq<CR>
map <leader>f :FZF<CR>

" Spellcheck
map <leader>oi :setlocal spell spelllang=it<CR>
map <leader>oe :setlocal spell spelllang=en<CR>
map <leader>oo :setlocal spell!<CR>

" Split navigation
" map <C-h> <C-w>h
" map <C-j> <C-w>j
" map <C-k> <C-w>k
" map <C-l> <C-w>l

" Tab navigation
map <leader>h :tabp<CR>
map <leader>l :tabn<CR>

" Compiler and preview
map <leader>c :w! \| !compiler <c-r>%<CR>
map <leader>p :!opout <c-r>%<CR><CR>

" <++>
nmap <leader><leader> /<++><Enter>c4l

" Haskell
autocmd FileType haskell setlocal shiftwidth=2 softtabstop=2

" sxhkd
autocmd BufWritePost *sxhkdrc !pkill -USR1 -x sxhkd

" shell script
autocmd FileType sh setlocal tabstop=4 noexpandtab softtabstop=0 shiftwidth=4

"""
""" Latex
"""

" Changes plaintex to tex for empty files
let g:tex_flavor='latex'

"""
""" Plugins
"""
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes for plugins
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'conornewton/vim-pandoc-markdown-preview'
Plug 'lervag/vimtex'

Plug 'lifepillar/vim-formal-package'
Plug 'lifepillar/vim-gruvbox8'

"
" Intellisense
"
" Stable version of coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Save files using sudo from within vim
Plug 'lambdalisue/suda.vim'

call plug#end()

"""
""" Set colorscheme
"""
colorscheme gruvbox8

source $HOME/.config/nvim/plug-config/coc.vim

"""
""" Set syntax highlighting for Proverif Library files (.pvl)
"""
autocmd BufNewFile,BufRead *.pvl set syntax=proverif
