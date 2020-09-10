" Projects switcher

"let g:project_enable_welcome = 0
"let g:project_use_nerdtree = 0

nnoremap <leader>opw :Welcome<CR>

" fugitive to use projects switch
set viminfo+=!

let g:PROJECTS = {
  \ '~/workspace/project_one': 'project_one',
  \ '~/workspace/project_two': 'project_two',
\ }


command! -complete=customlist,s:project_complete -nargs=1 Project cd <args>

function! s:project_complete(lead, cmdline, _) abort
  let results = keys(get(g:, 'PROJECTS', {}))

  " fallback to cheap fuzzy matching

  let regex = substitute(a:lead, '.', '[&].*', 'g')

  return filter(results, 'v:val =~ regex')
endfunction
