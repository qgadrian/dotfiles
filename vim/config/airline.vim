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

