"
" ####################################################################
" Plugins configurations
" ####################################################################
"

"
" airline
"
let g:airline_section_a = airline#section#create(['mode', 'crypt', 'paste', 'iminsert'])
let g:airline_section_z = '%l:%c'

let g:airline#extensions#clock#format = '%H:%M:%S'
let g:airline#extensions#clock#updatetime = 1000
let g:airline#extensions#clock#auto = 0
function! AirlineInit()
  let g:airline_section_z = airline#section#create([g:airline_section_z, g:airline_symbols.space, 'clock'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

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
" Open cursor in Dash
"
noremap <leader>da :Dash<CR>

"
" Vim rooter
"
let g:rooter_patterns = ['mix.lock', '.git/'] " Auto project root cd

"
" Startify
"
let g:startify_commands = [
  \ {'c': ['Terminal', ':terminal']},
  \ {'t': ['New tab', ':tabnew']},
\ ]

let g:startify_lists = [
  \ { 'type': 'commands',  'header': ['   Commands']       },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
\ ]

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

"
" increment-activator
"
let g:increment_activator_filetype_candidates = {
\   '_': [
\     ['enable', 'disable'],
\     ['enabled', 'disabled'],
\     ['info', 'warning', 'notice', 'error'],
\   ],
\   'ruby': [
\     ['module', 'class'],
\     ['context', 'describe'],
\   ]
\ }
