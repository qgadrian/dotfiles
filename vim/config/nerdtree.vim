"
" ####################################################################
" NERDtree configuration
" ####################################################################
"

let NERDTreeChDirMode = 0
let NERDTreeShowHidden = 1
"let NERDTreeHighlightCursorline = 1

" Icons
let g:WebDevIconsNerdTreeBeforeGlyphPadding = "" " To fix wrong padding
"let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
set encoding=UTF-8

"
" Highlight current cursor line
" http://vimdoc.sourceforge.net/htmldoc/autocmd.html#BufNewFile
"
augroup NerdCursor
  autocmd!
  autocmd BufEnter NERD_tree_* setlocal cursorline
  autocmd BufEnter NERD_tree_* highlight CursorLine gui=underline
  autocmd BufAdd NERD_tree_* setlocal cursorline
  autocmd BufAdd NERD_tree_* highlight CursorLine gui=underline
  autocmd BufLeave NERD_tree_* highlight clear CursorLine
  autocmd BufLeave NERD_tree_* setlocal nocursorline
  "autocmd BufAdd * highlight clear CursorLine
augroup END
