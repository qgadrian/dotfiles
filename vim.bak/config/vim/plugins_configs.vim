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
" Tab rename
" https://github.com/gcmt/taboo.vim
"
nmap <Leader>tr :TabooRename<Space>
let g:taboo_tab_format = '%S'
