"
" ####################################################################
" This config file provides custom mappings for multiple purposes
" ####################################################################
"

"
" Add empty lines without insert mode
"
nnoremap o o<Esc>
nnoremap O O<Esc>

"
" Search and replace word from cursor
"
" replace all words
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
vnoremap <Leader>s :%s/\<<C-r><C-w>\>/
" replace all words from cursor until the end the file
nnoremap <Leader>S :.,$s/\<<C-r><C-w>\>/
vnoremap <Leader>S :.,$s/\<<C-r><C-w>\>/
" no fucking idea
nnoremap <Leader>BS :1,.s/\<<C-r><C-w>\>/

"
" Sort and add comma to lines if missing
"
vnoremap <Leader>a, :g/.*[^,]$/ s/$/,/<CR>
vnoremap <Leader>sa, :s<CR>:'<,'>sort<CR>:'<,'>g/.*[^,]$/ s/$/,/<CR>

"
" Delete, yanking...
"
noremap <leader>D "_D
vnoremap <leader>D "_D
noremap <leader>dd "_dd
vnoremap <leader>dd "_dd
nnoremap <leader>d "_d
vnoremap <leader>d "_d
noremap <leader>y "*y
vnoremap <leader>y "*y
noremap <leader>yy "*yy
vnoremap <leader>yy "*yy
noremap <leader>Y "*Y
vnoremap <leader>Y "*Y
noremap <leader>p "*p
vnoremap <leader>p "*p
noremap <leader>P "*P
vnoremap <leader>P "*P
nnoremap x "_x
vnoremap x "_x
" replace currently selected text with default register
" without yanking it
vnoremap p "_dP

"
" Terminal
"

"noremap <leader>c  :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR>
"noremap ct :tabnew<CR>:let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR>
"noremap cb :new<CR>:let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>:startinsert<CR>cd $VIM_DIR<CR>
"noremap cbv :vnew<CR>:let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>:startinsert<CR>cd $VIM_DIR<CR>
noremap <leader>c :terminal<CR>
noremap <leader>ct :tabnew<CR>:terminal<CR>
noremap <leader>cb :new<CR>:terminal<CR>
noremap <leader>cvb :vnew<CR>:terminal<CR>
" Comment this mapping to support nested vim's
tnoremap <Esc> <C-\><C-n>
tnoremap <C-v><Esc> <Esc>

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
