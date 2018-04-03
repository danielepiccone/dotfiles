" The little commenter
" A small plugin to comment/uncomment lines in vim
" Author: Daniele Piccone <mail@danielepiccone.com>

function! s:getCommentBoundaries()
  return map(split(&commentstring, "%s", 1), { key, val -> escape(val, "*") })
endfunction

function! s:ensureLanguageSupport()
  if len(split(&commentstring, "%s")) > 0
    return 1
  endif
endfunction

function! s:toggleLineComment(line_number, should_comment)
  let [lboundary, rboundary] = s:getCommentBoundaries()
  let line = getline(a:line_number)

  if a:should_comment
    let changes = substitute(line, "^", lboundary . " ", "")
    let changes = substitute(changes, "$", " " . rboundary, "")
    call setline(a:line_number, changes)
  else
    let changes = substitute(line, lboundary . " ", "", "")
    let changes = substitute(changes, " " . rboundary . "$", "", "")
    call setline(a:line_number, changes)
  endif
endfunction

function! s:shouldComment()
  let line = getline(getcurpos()[1])
  let [lboundary, rboundary] = s:getCommentBoundaries()
  return !(line =~ "^\s*". lboundary)
  return !(line =~ "^[ \t]*". lboundary)
endfunction

function! ToggleComments() range
  if !s:ensureLanguageSupport()
    return
  endif

  let line_number = a:firstline
  let should_comment = s:shouldComment()

  while line_number <= a:lastline
    call s:toggleLineComment(line_number, should_comment)
    let line_number += 1
  endwhile

  if a:firstline == a:lastline
     " single line
  else
     execute "normal! gv"
  endif
endfunction

" ==============================================================================
" Initialize
" ==============================================================================

if exists('g:loaded_the_little_commenter')
  finish
endif
let g:loaded_the_little_commenter = 1

if has('unix')
  " this maps to C-/ in ubuntu
  vmap <C-_> :call ToggleComments()<CR>
  nmap <C-_> :call ToggleComments()<CR>
endif

if has('macunix')
  vmap <C-\> :call ToggleComments()<CR>
  nmap <C-\> :call ToggleComments()<CR>
endif
