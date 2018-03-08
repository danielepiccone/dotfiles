" if exists() ...

fun! s:getLcommentToken()
  let file_type = &ft
  let lcomment_token = ""

  if (file_type =~ "^javascript")
    let lcomment_token = "\/\/"
  endif

  if (file_type =~ "^vim")
    let lcomment_token = "\""
  endif

  return lcomment_token
endfun

fun! s:toggleLineComment(line_number, should_comment)
  let lcomment_token = s:getLcommentToken()
  let line = getline(a:line_number)

  if a:should_comment
    let changes = substitute(line, "^", lcomment_token . " ", "")
    call setline(a:line_number, changes)
  else
    let changes = substitute(line, lcomment_token . " ", "", "")
    call setline(a:line_number, changes)
  endif
endfun

fun! s:shouldComment()
  let line = getline(getcurpos()[1])
  let lcomment_token = s:getLcommentToken()
  return !(line =~ "^\s*". lcomment_token)
endfun

fun! ToggleComments() range
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
endfun
