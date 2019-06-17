"
" ####################################################################
" Mapping and configs for windows
" ####################################################################
"

" this needs to be first in order to make hightlight override of the colorscheme to work
syntax on

"
" Enable true colors
"
if (has("termguicolors"))
 set termguicolors
endif

"
" Theme, colorscheme, etc...
"
set background=dark
" Color scheme
let g:dracula_italic = 0 " https://github.com/dracula/vim/issues/81
colorscheme dracula
" For more highlight options see
" https://github.com/dracula/vim/blob/b7e11c087fe2a9e3023cdccf17985704e27b125d/colors/dracula.vim
hi LineNr ctermfg=lightgrey ctermbg=NONE cterm=NONE guifg=lightgrey guibg=#282a36 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#8b4852 gui=NONE

highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE
" Column width indicator
set colorcolumn=99
autocmd ColorScheme * highlight ColorColumn ctermbg=red
" Line number indicator
autocmd ColorScheme * highlight LineNr ctermfg=lightgrey

"
" Split behavior
"
set splitbelow
set splitright " Make splitted buffers open in right side

"
" Terminal view
"
"autocmd BufEnter * silent! lcd %:p:h
augroup terminal
  autocmd TermOpen * setlocal nospell
  autocmd TermOpen * setlocal nonumber
  autocmd TermOpen * setlocal wrap
  autocmd TermOpen * startinsert
augroup END

"
" Tabs
"
noremap <leader>tab :tabnew<CR>
" Move tabs with arrow keys
noremap <M-S-Left> gT
noremap <M-S-Right> gt
" Reorganize tabs
noremap <silent> <C-M-Left> :tabm -1<CR>
noremap <silent> <C-M-Right> :tabm +1<CR>

"
" Buffers
"
map <leader>b :new<CR>
map <leader>vb :vnew<CR>
" Remap arrow keys to change between buffers
noremap <C-S-Up> <C-w>k
noremap <C-S-Down> <C-w>j
noremap <C-S-Left> <C-w>h
noremap <C-S-Right> <C-w>l

"
" Resize buffers
"
nnoremap <silent> <Leader>9 :exe "vertical resize " . (winwidth(0) * 10/9)<CR>
noremap <silent> <Leader>0 :exe "vertical resize " . (winwidth(0) * 9/10)<CR>

noremap <leader>v3 :vertical resize 30<CR>
noremap <leader>v4 :vertical resize 40<CR>
noremap <leader>v5 :vertical resize 50<CR>
noremap <leader>v6 :vertical resize 60<CR>
noremap <leader>v7 :vertical resize 70<CR>
noremap <leader>v8 :vertical resize 80<CR>
" Equally resize buffers
noremap <leader>v= <C-w>=

"
" File type configs
"
autocmd FileType markdown setlocal spell wrap textwidth=80
" Delete git buffer when hidden
autocmd FileType gitcommit set bufhidden=delete
" Split buffer in git edit
if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
endif
