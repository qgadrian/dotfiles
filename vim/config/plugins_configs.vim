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
" Markdown
"
let g:vim_markdown_folding_disabled = 1
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
let vim_markdown_preview_github=1

"
" fzf
"
nnoremap <silent> <leader>. :Files .<CR>
nnoremap <silent> <leader>; :Rg<CR>

"
" Vim rooter
"
"let g:rooter_patterns = ['mix.lock'] " Auto project root cd

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

"
" Vinegar
"
let g:netrw_banner = 1
let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4 " set current buffer as open target always
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Markdown preview
let vim_markdown_preview_browser='Firefox'
let vim_markdown_preview_hotkey='<C-S-p>'

" Subtitution
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

nmap <leader>cr <plug>(SubversiveSubstituteRangeConfirm)
xmap <leader>cr <plug>(SubversiveSubstituteRangeConfirm)
nmap <leader>crr <plug>(SubversiveSubstituteWordRangeConfirm)

nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)

nmap <leader>ss <plug>(SubversiveSubstituteWordRange)
