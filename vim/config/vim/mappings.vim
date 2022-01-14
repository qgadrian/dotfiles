"
" ####################################################################
" This config file provides custom mappings for multiple purposes
" ####################################################################
"

" Buffers management
" Delete hidden buffers
nnoremap <leader>bd :Bdelete! hidden<CR>

"
" Add empty lines without insert mode
"
nnoremap o o<Esc>
nnoremap O O<Esc>

" annoying as fuck when wanted to save
noremap :W :w
noremap <leader>a <Nop>

"
" Sort and add comma to lines if missing
"
vnoremap <Leader>a, :g/.*[^,]$/ s/$/,/<CR>
vnoremap <Leader>sa, :s<CR>:'<,'>sort<CR>:'<,'>g/.*[^,]$/ s/$/,/<CR>

"
"" Shortcut to use blackhole register by default
"
nnoremap <leader>d "_d
vnoremap <leader>d "_d
nnoremap <leader>D "_D
vnoremap <leader>D "_D
nnoremap <leader>c "_c
vnoremap <leader>c "_c
nnoremap <leader>C "_C
vnoremap <leader>C "_C
nnoremap <leader>x "_x
vnoremap <leader>x "_x
nnoremap <leader>X "_X
vnoremap <leader>X "_X

" Easy word yank to clipboard
nnoremap <leader>yw "*yiw

"
" Terminal
"
"

"tabs
noremap <leader>tab :tabnew<CR>:terminal<CR>
" buffers & terminal
noremap <leader>term :let $VIM_DIR=expand('%:p:h')<CR>:term!<CR>cd $VIM_DIR<CR>
noremap <leader>tb :new<CR>:let $VIM_DIR=expand('FindRootDirectory()')<CR>:terminal<CR>cd $VIM_DIR<CR>
noremap <leader>tvb :vnew<CR>:let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR>
" Comment this mapping to support nested vim's
tnoremap <Esc> <C-\><C-n>
tnoremap <C-v><Esc> <Esc>

"autocmd TerminalOpen * call :startintert<CR>cd expand(:pwd)<CR>

"
" Skip sending escape characters for arrow keys in terminal mode
"
tnoremap <C-S-Up> <Nop>
tnoremap <C-S-Down> <Nop>
tnoremap <C-S-Left> <Nop>
tnoremap <C-S-Right> <Nop>
tnoremap <M-S-Up> <Nop>
tnoremap <M-S-Down> <Nop>
tnoremap <M-S-Left> <Nop>
tnoremap <M-S-Right> <Nop>
tnoremap <S-Up> <Nop>
tnoremap <S-Down> <Nop>
tnoremap <silent> <S-Left> <Esc>b
tnoremap <silent> <S-Right> <Esc>f

"
" Other mappings
"
" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

" Avoid blowup
nnoremap <c-z> <nop>

" Copy file path to clipboard
noremap <leader>ccp :let @+ = expand("%")<CR>

" buffer management
nnoremap <leader>rf :e!<CR>

" free move
noremap <Up> g<Up>
noremap <Down> g<Down>

" remove mappings that override jumps
" unmap <C-i>

" highlight current word without moving
:nnoremap <leader>hw :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" Remove search highlight
nmap <esc><esc> :noh<return>

" Telescope plugins
noremap <silent> <leader>fc <Cmd>lua require('telescope').extensions.frecency.frecency()<CR>
noremap <silent> <leader>fp :lua require('telescope').extensions.projects.projects()<CR>

" execute the q macro over just the selected lines
xnoremap Q :'<,'>:normal @q<CR>

" quick search and replace
nmap <Leader>ss :%s///g<Left><Left><Left>
