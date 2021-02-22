"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim ftplugin file
"
" Language: javascript.jsx
" Maintainer: MaxMEllon <maxmellon1994@gmail.com>
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" modified from html.vim
" For matchit plugin
if exists("loaded_matchit")
  let b:match_ignorecase = 0
  let b:match_words = '(:),\[:\],{:},<:>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
endif

" For andymass/vim-matchup plugin
if exists("loaded_matchup")
  setlocal matchpairs=(:),{:},[:],<:>
  let b:match_words = '<\@<=\([^/][^ \t>]*\)\g{hlend}[^>]*\%(/\@<!>\|$\):<\@<=/\1>'
  let b:match_skip = 's:comment\|string'
endif

let b:jsx_pretty_old_cms = &l:commentstring

augroup jsx_comment
  autocmd! CursorMoved <buffer>
  autocmd CursorMoved <buffer> call jsx_pretty#comment#update_commentstring(b:jsx_pretty_old_cms)
augroup end

function! jsx_pretty#comment#update_commentstring(original)
  let line = getline(".")
  let col = col('.')
  if line !~# '^\s*$' && line[: col - 1] =~# '^\s*$'    " skip indent
    let col = indent('.') + 1
  endif
  let syn_start = s:syn_name(line('.'), col)
  let save_cursor = getcurpos()

  if syn_start =~? '^jsx'
    if line =~ '^\s*//'
      let &l:commentstring = '// %s'
    elseif s:syn_contains(line('.'), col, 'jsxTaggedRegion')
      let &l:commentstring = '<!-- %s -->'
    elseif syn_start =~? '^jsxAttrib'
      let &l:commentstring = '// %s'
    else
      let &l:commentstring = '{/* %s */}'
    endif
  else
    let &l:commentstring = a:original
  endif

  " Restore the cursor position
  call setpos('.', save_cursor)
endfunction

function! s:syn_name(lnum, cnum)
  let syn_id = get(synstack(a:lnum, a:cnum), -1)
  return synIDattr(syn_id, "name")
endfunction

function! s:syn_contains(lnum, cnum, syn_name)
  let stack = synstack(a:lnum, a:cnum)
  let syn_names = map(stack, 'synIDattr(v:val, "name")')
  return index(syn_names, a:syn_name) >= 0
endfunction

setlocal suffixesadd+=.jsx
