"
" ####################################################################
" Plugins configurations
" ####################################################################
"

"
" Elixir
"
let g:mix_format_on_save = 1
let g:mix_format_silent_errors = 1

"
" Nerd commenter
"
map <leader>/ <plug>NERDCommenterToggle

"
" fzf
"
nnoremap <silent> <leader>. :Files .<CR>
nnoremap <silent> <leader>; :Rg<CR>

"
" Easy motion
"
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

"
" Tab rename
"
nmap <Leader>tr :TabooRename<Space>
