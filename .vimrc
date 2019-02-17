" Inspiration
" http://dougblack.io/words/a-good-vimrc.html
" https://github.com/skwp/dotfiles

set nocompatible              " be iMproved, required

let mapleader=" "       " leader is space

" https://medium.com/@dnrvs/per-project-settings-in-nvim-fc8c8877d970
" Allow per project .n?vimrv files to be loaded.
set exrc
set secure

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
let g:EditorConfig_max_line_indicator='exceeding'
" Allow per project configuration with .lvimrc files
" Plug 'embear/vim-localvimrc'
" Quick commenting with <leader>c<space> and some more
Plug 'scrooloose/nerdcommenter'
" Support * search in visual mode
Plug 'thinca/vim-visualstar'
" Highlight yanked text
Plug 'machakann/vim-highlightedyank'
" Quick navigation: https://vimawesome.com/plugin/easymotion
Plug 'easymotion/vim-easymotion'
" Align text around something: https://vimawesome.com/plugin/vim-easy-align
Plug 'junegunn/vim-easy-align'


""" AUTOCOMPLETE
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
" Use deoplete
let g:deoplete#enable_at_startup = 1



" Async linting of code
Plug 'w0rp/ale'
" https://github.com/w0rp/ale#5xi-how-can-i-use-the-quickfix-list-instead-of-the-loclist
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1


" Pretty code is nice!
" Plug 'prettier/vim-prettier', {
"   \ 'do': 'yarn install',
"   \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml'] }

""" JENKINS / GROOVY
Plug 'martinda/Jenkinsfile-vim-syntax'
""" JAVASCRIPT

" https://davidosomething.com/blog/vim-for-javascript/
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'othree/es.next.syntax.vim', { 'for': 'javascript' }
Plug 'gavocanov/vim-js-indent'
Plug 'mxw/vim-jsx', { 'for': 'javascript' }
Plug 'moll/vim-node', { 'for': 'javascript' }

Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'Quramy/vim-js-pretty-template'

Plug 'galooshi/vim-import-js', { 'do': 'test `which importjsd` \|\| npm install -g import-js' }

""" HTML

Plug 'othree/html5.vim'
" Zen coding
" https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL
Plug 'mattn/emmet-vim', { 'for': 'html' }

" Handlebars templating
Plug 'mustache/vim-mustache-handlebars'

""" CSS

Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'iloginow/vim-stylus', { 'for': 'stylus' }

""" MARKDOWN

Plug 'rhysd/vim-gfm-syntax', { 'for': 'markdown' }

""" CS/RAZOR

Plug 'OrangeT/vim-csharp'

""" GIT

" git integration
" Plug 'tpope/vim-fugitive'

" git syntax
Plug 'tpope/vim-git'
" git gutter info
Plug 'airblade/vim-gitgutter'

""" FOLDING

" custom fold text with indentation
Plug 'Konfekt/FoldText'
" Python folding
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }

""" THEMING
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'jmcantrell/vim-virtualenv'
Plug 'edkolev/tmuxline.vim'

""" FILES

" Fast fuzzy file finder
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files --exclude-standard -co |& egrep -v "\.(png|jpg|jpeg|gif)$|node_modules"']

" Better searches with silver searcher
" https://robots.thoughtbot.com/faster-grepping-in-vim
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " create command :Ag to search like grep but with custom args.
  command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  nnoremap \ :Ag<SPACE>

endif


""" TMUX SPLITS
Plug 'christoomey/vim-tmux-navigator'

Plug 'scrooloose/nerdtree'

let NERDTreeQuitOnOpen=1
map <C-e> :NERDTreeFind<cr>

let NERDTreeWinSize = 40

" Add plugins to &runtimepath
call plug#end()
" }}}
" Theming {{{
syntax enable           " enable syntax processing
" https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized
let g:airline_theme = 'solarized'
let g:airline_solarized_bg = 'dark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#format = 2
let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tmuxline#snapshot_file = "~/.tmux-statusline-colors.conf"
" Based on the original value from airline, remove the file scroll
" percentage.
let g:airline_section_z = '%#__accent_bold#%{g:airline_symbols.linenr}%#__accent_bold#%4l%#__restore__#%#__restore__#%#__accent_bold#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#%#__restore__# :%3v'
" original:          %3p%% %#__accent_bold#%{g:airline_symbols.linenr}%#__accent_bold#%4l%#__restore__#%#__restore__#%#__accent_bold#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#%#__restore__# :%3v

" Custom coloring
" https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
highlight Search ctermfg=15 ctermbg=57
if g:airline_solarized_bg == 'dark'
  highlight Folded ctermfg=136 ctermbg=25
else
  highlight Folded ctermfg=0 ctermbg=39
endif

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
nnoremap <silent> <leader>h :nohlsearch<CR>

" Map to search for current word in PWD
nnoremap <silent> <leader>* :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" http://stackoverflow.com/a/2288438 and read comments too
" Really good for searching, might be bad for replacing though.
set ignorecase
set smartcase

" Live preview of replace result
if exists('&inccommand')
  " Only in neovim so far
  set inccommand=split
endif

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
if has('nvim')
  " See :h clipboard-provider
  set clipboard+=unnamedplus
else
  set clipboard+=unnamed
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
