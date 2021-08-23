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
