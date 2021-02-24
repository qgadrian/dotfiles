" Projects switcher

"let g:project_enable_welcome = 0
"let g:project_use_nerdtree = 0

nnoremap <leader>opw :Welcome<CR>

" fugitive to use projects switch
set viminfo+=!

"if !exists('g:PROJECTS')
let g:PROJECTS = {
  \ '~/workspace/project_one': 'project_one',
  \ '~/workspace/project_two': 'project_two',
\ }
"endif

"augroup project_discovery
  "autocmd!
  "autocmd User Fugitive let g:PROJECTS[fnamemodify(fugitive#repo().dir(), ':h')] = 1
"augroup END

command! -complete=customlist,s:project_complete -nargs=1 Project cd <args>

function! s:project_complete(lead, cmdline, _) abort
  let results = keys(get(g:, 'PROJECTS', {}))

  "echoerr results

  " use projectionist if available
  "if exists('*projectionist#completion_filter')
    "return projectionist#completion_filter(results, a:lead, '/')
  "endif

  " fallback to cheap fuzzy matching

  let regex = substitute(a:lead, '.', '[&].*', 'g')

  return filter(results, 'v:val =~ regex')
endfunction
