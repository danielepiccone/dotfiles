" File:        vim-index-tabs.vim
" Maintainer:  Daniele Piccone <mail@danielepiccone.com>
" Description: Custom tabline for Gvim omitting index.* filenames
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.

if (exists("g:loaded_index_tabs_vim") && g:loaded_index_tabs_vim) || &cp
  finish
endif

let g:loaded_index_tabs_vim = 1

function! TabLabel()
  if expand('%') == ""
    return '[No Name]'
  endif

  let l:absolutePath=substitute(expand('%:p'), "/index.", "/➔", "")

  let l:path=split(l:absolutePath, "/")
  let l:fname=l:path[-1]
  let l:mod=""

  if &mod
    let l:mod="+"
  endif

  return l:mod.l:path[-2]."/".l:fname
endfunction

set guitablabel=%{TabLabel()}
