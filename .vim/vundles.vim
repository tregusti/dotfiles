" ========================================
" Vim plugin configuration
" ========================================
"
" This file contains the list of plugin installed using vundle plugin manager.
" Once you've updated the list of plugin, you can run vundle update by issuing
" the command :BundleInstall from within vim or directly invoking it from the
" command line with the following syntax:
" vim --noplugin -u vim/vundles.vim -N "+set hidden" "+syntax on" +BundleClean! +BundleInstall +qall
" Filetype off is required by vundle
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
" set rtp+=~/.vim/vundles/ " Submodules

call vundle#begin()

" let Vundle manage Vundle (required)
Plugin 'VundleVim/Vundle.vim'

" {{{ File navigation
Plugin 'ctrlpvim/ctrlp.vim'
" }}}
" Completion {{{
Plugin 'SirVer/ultisnips'
Plugin 'Valloric/YouCompleteMe'
" For YCM don't forget to compile on first install and some more times:
" https://github.com/Valloric/YouCompleteMe#mac-os-x
" }}}

" All of your Plugins must be added before the following line
call vundle#end()            " required

"Filetype plugin indent on is required by vundle
filetype plugin indent on


" vim:foldmethod=marker:foldlevel=0
