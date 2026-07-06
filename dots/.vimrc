" Minimal bare-Vim fallback.
"
" This is NOT the main editor config — that's Neovim, under dots/.config/nvim/.
" This file exists only so that a plain `vim` on a server that lacks Neovim is
" tolerable. No plugins, nothing fancy. Neovim does not read this file.
"
" Every option below is citable with `:help '<name>'` inside Vim.

set nocompatible            " Don't emulate vi; enable Vim features. :help 'compatible'
syntax on                   " Syntax highlighting. :help :syntax-on
filetype plugin indent on   " Filetype detection + lang plugins + indent. :help :filetype-overview

set backspace=indent,eol,start  " Let backspace cross indent/line-start. :help 'backspace'
set hidden                  " Switch away from a modified buffer without saving. :help 'hidden'
                            " (:q on a modified buffer still nags — hidden only
                            "  affects buffer *switching*, not quitting.)

set incsearch               " Show matches while typing the search. :help 'incsearch'
set hlsearch                " Highlight all matches. :help 'hlsearch'
set ignorecase              " Case-insensitive search... :help 'ignorecase'
set smartcase               " ...unless the pattern has a capital. :help 'smartcase'

set expandtab               " Tabs insert spaces. :help 'expandtab'
set shiftwidth=2            " Indent width for <<, >>, ==. :help 'shiftwidth'
set softtabstop=2           " Spaces a <Tab> feels like while editing. :help 'softtabstop'

set number                  " Line numbers. :help 'number'
set scrolloff=4             " Keep 4 lines of context around the cursor. :help 'scrolloff'
set wildmenu                " Enhanced command-line completion menu. :help 'wildmenu'
set mouse=a                 " Enable the mouse in all modes. :help 'mouse'
set laststatus=2            " Always show the status line. :help 'laststatus'

" Exit insert mode with 'jk' (matches the Neovim config). :help :inoremap
inoremap jk <Esc>
