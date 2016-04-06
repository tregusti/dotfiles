" Inspiration
" http://dougblack.io/words/a-good-vimrc.html
" https://github.com/skwp/dotfiles

set nocompatible              " be iMproved, required
filetype off                  " required for Vundle

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all 
" the plugins.
let mapleader=","       " leader is comma

" Vundle {{{
source ~/.vim/vundles.vim
" }}}
" Colors {{{
syntax enable           " enable syntax processing
" }}}
" Whitespace {{{
set expandtab       " tabs are spaces
set softtabstop=2   " number of spaces in tab when editing
set shiftwidth=2    " number of spaces in indentation with <<, >> and ==.

" http://vim.wikia.com/wiki/Erasing_previously_entered_characters_in_insert_mode
set backspace=indent,eol,start
" }}}
" UI config {{{
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
" }}}
" Searching {{{
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
" }}}
" Folding  {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" space open/closes folds
nnoremap <space> za
set foldmethod=syntax   " fold based on code syntax
" }}}
" Movement {{{

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Exit INSERT mode with quick `jk`
imap jk <Esc>
" }}}
" File handling {{{
set noswapfile
nnoremap <f3> :Explore %:p:h<cr>
" }}}
runtime ~/.vim/settings/*.vim


" highlight last inserted text
nnoremap gV `[v`]

" Tmux {{{

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" }}}
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

" }}}

" vim:foldmethod=marker:foldlevel=0