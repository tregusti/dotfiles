" Inspiration
" http://dougblack.io/words/a-good-vimrc.html
" https://github.com/skwp/dotfiles

set nocompatible              " be iMproved, required

let mapleader=" "       " leader is space

" Plugs {{{
" https://github.com/junegunn/vim-plug#example
call plug#begin('~/.vim/plugged')

""" GENERIC

" Sensible defaults
Plug 'tpope/vim-sensible'
" Surround stuff
Plug 'tpope/vim-surround'
" Snippets for vim
Plug 'SirVer/ultisnips'
" Repeat plugin commands with . too
Plug 'tpope/vim-repeat'
" Pairwise commands with [ and ]
Plug 'tpope/vim-unimpaired'
" Mimic multiple cursors in Atom and Sublime
Plug 'terryma/vim-multiple-cursors'
" Configure indent and whitespaace rules per project
Plug 'editorconfig/editorconfig-vim'
" Allow per project configuration with .lvimrc files
Plug 'embear/vim-localvimrc'
" Quick commenting with <leader>c<space> and some more
Plug 'scrooloose/nerdcommenter'
" Support * search in visual mode
Plug 'thinca/vim-visualstar'

""" JAVASCRIPT

" https://davidosomething.com/blog/vim-for-javascript/
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'gavocanov/vim-js-indent'
Plug 'othree/es.next.syntax.vim', { 'for': 'javascript' }
Plug 'mxw/vim-jsx', { 'for': 'javascript' }
Plug 'moll/vim-node', { 'for': 'javascript' }

""" HTML

Plug 'othree/html5.vim'
" Zen coding
" https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL
Plug 'mattn/emmet-vim', { 'for': 'html' }

""" CSS

Plug 'groenewege/vim-less', { 'for': 'less' }

""" MARKDOWN

Plug 'rhysd/vim-gfm-syntax', { 'for': 'markdown' }

""" CS/RAZOR

Plug 'OrangeT/vim-csharp'

""" GIT

" git integration
Plug 'tpope/vim-fugitive'

map <leader>g :Gstatus<cr>

" git syntax
Plug 'tpope/vim-git'
" git gutter info
Plug 'airblade/vim-gitgutter'

""" FOLDING

" custom fold text with indentation
Plug 'Konfekt/FoldText'
" Python folding
Plug 'tmhedberg/SimpylFold'

""" THEMING
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jmcantrell/vim-virtualenv'
Plug 'edkolev/tmuxline.vim'

""" FILES

" Better searches with silver searcher
Plug 'mileszs/ack.vim'
let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack

" Fast fuzzy file finder
Plug 'ctrlpvim/ctrlp.vim'

Plug 'scrooloose/nerdtree'

let NERDTreeQuitOnOpen=1
map <C-e> :NERDTreeFind<cr>

let NERDTreeWinSize = 40

" Add plugins to &runtimepath
call plug#end()
" }}}
" Theming {{{
syntax enable           " enable syntax processing
let g:airline_theme = 'solarized'
let g:airline_solarized_bg = 'light'
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#format = 2
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tmuxline#snapshot_file = "~/.tmux-statusline-colors.conf"
" Based on the original value from airline, remove the file scroll
" percentage.
let g:airline_section_z = '%#__accent_bold#%{g:airline_symbols.linenr}%#__accent_bold#%4l%#__restore__#%#__restore__#%#__accent_bold#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#%#__restore__# :%3v'
" original:          %3p%% %#__accent_bold#%{g:airline_symbols.linenr}%#__accent_bold#%4l%#__restore__#%#__restore__#%#__accent_bold#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#%#__restore__# :%3v

" https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
highlight Folded ctermfg=0 ctermbg=39
highlight Search ctermfg=15 ctermbg=57

" Hightlight code blocks in markdown files
let g:markdown_fenced_languages = ['html', 'javascript', 'js=javascript', 'json=javascript']

" }}}
" Whitespace {{{
set expandtab       " tabs are spaces
set softtabstop=2   " number of spaces in tab when editing
set shiftwidth=2    " number of spaces in indentation with <<, >> and ==.
" }}}
" UI config {{{
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]

" Block cursor in NORMAL
" Line cursor in INSERT
" https://github.com/mintty/mintty/wiki/Tips#mode-dependent-cursor-in-vim
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"
" }}}
" Searching {{{
set hlsearch            " highlight matches
" turn off search highlight
nnoremap <silent> <leader><space> :nohlsearch<CR>

" http://stackoverflow.com/a/2288438 and read comments too
" Really good for searching, might be bad for replacing though.
set ignorecase
set smartcase

" }}}
" Folding  {{{
set foldenable          " enable folding
set foldlevelstart=0    " close all folds by default
set foldnestmax=10      " 10 nested fold max
" open/closes folds
nnoremap <leader>f za
nnoremap <leader>F zA

set foldmethod=syntax   " fold based on code syntax

" https://github.com/tmhedberg/SimpylFold#configuration
autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

nnoremap <silent> <f8> :call MochaFolds()<cr>
" }}}
" Movement {{{

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Exit INSERT mode with quick `jk`
imap jk <Esc>

" https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally#easier-split-navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" More natural split directions
set splitbelow
set splitright
" }}}
" File handling {{{
set noswapfile
set autowrite   " Autosave buffers
nnoremap <f3> :Explore %:p:h<cr>

autocmd BufWritePre *.py,*.js,*.json,*.cs,*.xml,*.html,*.less,*.css :call <SID>StripTrailingWhitespaces()
" }}}
for rcfile in split(globpath("~/.vim/settings", "*.vim"), '\n')
  execute('source '.rcfile)
endfor

" Make yanked stuff be exposed to OS clipboard.
" If this is not set, you can always yank to register + manually.
if $TMUX == ''
  set clipboard=unnamed
endif

" Delete current buffer and go to previous buffer
nnoremap <leader>bk :b #\|:bd #<cr>

nnoremap <leader>r :so ~/.vimrc<cr>

" highlight last inserted text
nnoremap gV `[v`]

" Custom functions {{{

" toggle between number and relativenumber
function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunc

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
  " save last search & cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction

function! MochaFolds()
  let originalline = line(".")
  set foldlevel=0
  call feedkeys("gg", 'tx')
  call feedkeys("zX", 'tx')
  let curr = 0
  let prev = -1
  while curr != prev
    echom "line " . curr
    if getline(".") =~ "^\\s*\\(describe\\|context\\)"
      call feedkeys("zo", 'tx')
      echom "match"
    endif
    call feedkeys("zj", 'tx')
    let prev = curr
    let curr = line(".")
  endwhile
  set nohlsearch
  call cursor(originalline, 0)
endfunction

" }}}

" vim:foldmethod=marker:foldlevel=0
