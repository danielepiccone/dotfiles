" The little commenter

let s:comment_leaders_map = {
  \ "c": '\/\/',
  \ "cpp": '\/\/',
  \ "go": '\/\/',
  \ "java": '\/\/',
  \ "javascript": '\/\/',
  \ "javascript.jsx": '\/\/',
  \ "lua": '--',
  \ "scala": '\/\/',
  \ "php": '\/\/',
  \ "python": '#',
  \ "ruby": '#',
  \ "rust": '\/\/',
  \ "sh": '#',
  \ "desktop": '#',
  \ "fstab": '#',
  \ "conf": '#',
  \ "profile": '#',
  \ "bashrc": '#',
  \ "bash_profile": '#',
  \ "mail": '>',
  \ "eml": '>',
  \ "bat": 'REM',
  \ "ahk": ';',
  \ "vim": '"',
  \ "tex": '%'
  \ }

function! s:ensureLanguageSupport()
  if has_key(s:comment_leaders_map, &ft)
    return 1
  endif
endfunction

function! s:getCommentLeader()
  if has_key(s:comment_leaders_map, &ft)
    let comment_leader = s:comment_leaders_map[&ft]
  else
    let comment_leader = '#'
  endif
  return comment_leader
endfunction

function! s:toggleLineComment(line_number, should_comment)
  let comment_leader = s:getCommentLeader()
  let line = getline(a:line_number)

  if a:should_comment
    let changes = substitute(line, "^", comment_leader . " ", "")
    call setline(a:line_number, changes)
  else
    let changes = substitute(line, comment_leader . " ", "", "")
    call setline(a:line_number, changes)
  endif
endfunction

function! s:shouldComment()
  let line = getline(getcurpos()[1])
  let comment_leader = s:getCommentLeader()
  return !(line =~ "^\s*". comment_leader)
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
