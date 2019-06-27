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
nnoremap <silent> <leader>. :Ag<CR>
nnoremap <silent> <leader>; :Rg<CR>

"
" Open cursor in Dash
"
noremap <leader>da :Dash<CR>

"
" Vim rooter
"
let g:rooter_patterns = ['mix.exs', '.git/'] " Auto project root cd

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
