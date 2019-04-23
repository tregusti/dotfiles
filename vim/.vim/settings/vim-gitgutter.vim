" Gutter signs slows down rendering alot on windows at least
let g:gitgutter_enabled = 1
let g:gitgutter_signs = 1

nnoremap <leader>gg <Plug>GitGutterLineHighlightsToggle<CR>
nnoremap <leader>hs <Plug>GitGutterStageHunk<CR>
nnoremap <leader>hu <Plug>GitGutterUndoHunk<CR>
