"
" increment-activator
"
let g:increment_activator_filetype_candidates = {
\   '_': [
\     ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten'],
\     ['right', 'left'],
\     ['enable', 'disable'],
\     ['enabled', 'disabled'],
\     ['debug', 'info', 'warning', 'error'],
\     ['debug', 'info', 'warn', 'error'],
\     ['open', 'close'],
\     ['new', 'old'],
\     ['start', 'stop'],
\     ['before', 'after'],
\     ['get', 'post', 'put', 'delete'],
\     ['pick', 'reword', 'edit', 'squash', 'fixup', 'drop', 'reset', 'merge'],
\     ['next', 'previous'],
\     ['desc', 'asc']
\   ],
\   'ruby': [
\     ['first', 'last'],
\     ['module', 'class'],
\     ['context', 'describe', 'it'],
\   ],
\   'javascript': [
\     ['mount', 'shallow', 'render']
\   ],
\   'elixir': [
\     ['def', 'defp'],
\     ['@defdoc', '@moduledoc'],
\     ['ok', 'error'],
\     ['assert', 'refute'],
\     ['is_atom', 'is_list', 'is_binary', 'is_map', 'is_number'],
\     ['gt', 'eq', 'lt'],
\   ],
\ }
