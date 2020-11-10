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
" Lightline configuration
"
"
" To show the full absolute path use `absolutepath` instead of `filename`
"
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'cwd' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead'
  \ },
  \ 'component_expand': {
  \   'cwd': '%{getcwd()}'
  \ }
\ }

" To control the ouput of the git branch section add this:
"
" 'component': {
"  'gitbranch': '%3l:%-2v%<',
"  'fugitive': 'LightlineFugitive',
" },
"
" `gitbranch` contains a shortener for the text
" `fugitive` calls the LightlineFugitive function that can be used to edit the
" text
"

" Add this to `component_function` to show the full relative path
" \   'filename': 'LightlineFilename',

" Only works for vim-fugitive
" for `vim-gitbranch` replace `let root` with:
"  let root = fnamemodify(get(b:, 'gitbranch_path'), ':h:h')
"
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

function! LightlineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*FugitiveHead')
      let mark = ''  " edit here for cool mark
      let branch = FugitiveHead()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

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
hi Directory ctermfg=141 ctermbg=NONE cterm=NONE guifg=#54ff9f guibg=NONE gui=NONE

highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE
" Column width indicator
set colorcolumn=80
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
  "autocmd TermEnter * call timer_start(200, { tid -> startintert })
augroup END

"
" Tabs
"
" Move tabs with arrow keys
noremap <M-S-Left> gT
noremap <M-S-Right> gt
nnoremap <silent> <M-h> :tabprevious<CR>
nnoremap <silent> <M-l> :tabnext<CR>
" Reorganize tabs
noremap <silent> <C-M-Left> :tabm -1<CR>
noremap <silent> <C-M-Right> :tabm +1<CR>

"
" Buffers
"
map <leader>b :new<CR>
map <leader>vb :vnew<CR>
" Remap arrow keys to change between buffers
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-S-Up> <C-w>k
noremap <C-S-Down> <C-w>j
noremap <C-S-Left> <C-w>h
noremap <C-S-Right> <C-w>l

"
" Resize buffers
"
nnoremap <silent> <Leader>9 :exe "vertical resize " . (winwidth(0) * 10/9)<CR>
noremap <silent> <Leader>0 :exe "vertical resize " . (winwidth(0) * 9/10)<CR>

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

" Fix cmd height size when sourcing files
" See https://stackoverflow.com/a/15648665/1214625
function FixHeight()
  set cmdheight=2
endfunction

"
" performance tests
"
set lazyredraw
set ttyfast
