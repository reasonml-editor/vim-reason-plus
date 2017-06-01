function! neomake#makers#ft#reason#merlin()
  let l:maker = {}
  function! l:maker.get_list_entries(jobinfo)
    return merlin#ErrorLocList()
  endfunction
  return l:maker
endfunction
