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
" fzf
"
nnoremap <silent> <leader>. :Files .<CR>
nnoremap <silent> <leader>; :Rg<CR>

"
" Tab rename
"
nmap <Leader>tr :TabooRename<Space>
