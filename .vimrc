runtime! defaults.vim

syntax on

" Richer colors
if (has("termguicolors"))
    set termguicolors
endif

" Colors/bkgnd
set background=dark
colorscheme torte

set ttimeoutlen=0

" No need for vi compat
set nocompatible

" Ignore case if search=nocaps; otherwise strict
set ignorecase
set smartcase

" Formatting
set tabstop=4
set shiftwidth=4
set softtabstop=4
set copyindent
set autoindent
set expandtab

set showcmd

" Unhighlight search terms if <esc><esc><ret>
nnoremap <silent> <esc><esc> :noh<cr>

" Show trailing whitespace in RED
highlight ExtraWhitespace ctermbg=LightYellow guibg=#666600
match ExtraWhitespace /\s\+$/
                                                           

" Remove whitespace if <leader><r><ret>
nnoremap <leader>r :%s/\s\+$//e<cr>

" Allow up to 1k lines to be saved in internal vim buffer
set viminfo='100,<1000,s10,h

" Shows char/line number in bottom right
set ruler

" Set up search highlighting
hi Search ctermbg=black ctermfg=white guibg=#000000 guifg=#FFFFFF
hi CurSearch ctermbg=red ctermfg=black guibg=#FF0000 guifg=#000000

" Source local vim rules
if filereadable(expand("$HOME/.vimrc.local"))
  source "$HOME/.vimrc.local"
endif
