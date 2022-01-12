"
" ####################################################################
" Custom functions
" ####################################################################
"
"
" TODO migrate this functions to the new nvim lua API
" See: https://github.com/neovim/neovim/pull/16752
"

"
" Open HTML in browser
"
" nnoremap <C-S-p> :!open -a Safari %<CR><CR>

"
" Remove trailing spaces
"
function! TrimWhiteSpaces()
  %s/\s*$//
  ''
endfunction

set list listchars=trail:.,extends:>
autocmd FileWritePre * call TrimWhiteSpaces()
autocmd FileAppendPre * call TrimWhiteSpaces()
autocmd FilterWritePre * call TrimWhiteSpaces()
autocmd BufWritePre * call TrimWhiteSpaces()

"
" Session
"
"
function! SaveSession(name)
  execute "mks! ~/.vim/sessions/". a:name .".vim"
endfunction

function! LoadSession(name)
  execute "source ~/.vim/sessions/". a:name .".vim"
endfunction

"
" Surround words
"
function! WrapSelect(front)
    "puts characters around the selected text.
    let l:front = a:front
    if (a:front == '[')
        let l:back = ']'
    elseif (a:front == '(')
        let l:back = ')'
    elseif (a:front == '{')
        let l:back = '}'
    elseif (a:front == '<')
        let l:back = '>'
    elseif (a:front =~ " ")
        let l:split = split(a:front)
        let l:back = l:split[1]
        let l:front = l:split[0]
    else
        let l:back = a:front
    endif
    "execute: concat all these strings. '.' means "concat without spaces"
    "norm means "run in normal mode and also be able to use \<C-x> characters"
    "gv means "get the previous visual selection back up"
    "c means "cut visual selection and go to insert mode"
    "\<C-R> means "insert the contents of a register. in this case, the
    "default register"
    execute 'norm! gvc' . l:front. "\<C-R>\""  . l:back
endfunction
vnoremap <C-s> :<C-u>call WrapSelect(input('Wrapping? Give both (space separated) or just the first one: '))<cr>

"
" Case
"

function! ToSnakeCase()
  s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g
endfunction

function! ToCamelCase()
  s#_*\(\u\)\(\u*\)#\1\L\2#g
endfunction

"
" Emojis
"
set completefunc=emoji#complete

function! ReplaceEmojis()
  %s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g
endfunction

nnoremap <leader>re :call ReplaceEmojis()<CR>

"
" Highlight row/column shortcut
"
nnoremap <leader>hcl :call ToggleCursorLine()<CR>
set nocursorline
function! ToggleCursorLine()
  let l:current = synIDattr(synIDtrans(hlID("CursorLine")), "fg")
  if (l:current == 'white')
    set nocursorline
    highlight clear CursorLine
  else
    set cursorline
    highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=#424450 guifg=white
  endif
endfunction

" Replace words
function! ReplaceAllWord(replaceWith)
  let wordUnderCursor = expand("<cword>")
  let l:replaceWith = a:replaceWith
  echo 'Replace `' . wordUnderCursor . "` with `" . a:replaceWith . "`"
  execute '%s/' . wordUnderCursor . '/' . replaceWith . '/gc'
endfunction
nnoremap <leader>raw :<C-u>call ReplaceAllWord(input('Replace word with: '))<CR>

" JSON formatter
function! FormatJSON()
  %!python -m json.tool
endfunction

"
" Documentation: http://vimdoc.sourceforge.net/htmldoc/autocmd.html
"
" Restore last deleted buffer
autocmd BufDelete * let g:restore_deleted_buffer = expand("<afile>:p")
nnoremap <leader>rdb :e <C-R>=fnameescape(g:restore_deleted_buffer)<CR><CR>

autocmd BufLeave * let g:restore_leaved_buffer = expand("<afile>:p")
nnoremap <leader>rlb :e <C-R>=fnameescape(g:restore_deleted_buffer)<CR><CR>
