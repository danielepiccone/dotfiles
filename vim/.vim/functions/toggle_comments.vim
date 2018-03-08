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

fun! s:toggleLineComment(line_number)
  let lcomment_token = s:getLcommentToken()
  let line = getline(a:line_number)

  if (line =~ "^\s*" . lcomment_token)
    let changes = substitute(line, lcomment_token . " ", "", "")
    call setline(a:line_number, changes)
  else
    let changes = substitute(line, "^", lcomment_token . " ", "")
    call setline(a:line_number, changes)
  endif
endfun


fun! ToggleComments() range
  echo a:firstline a:lastline

  let line_number = a:firstline
  while line_number <= a:lastline
    call s:toggleLineComment(line_number)
    let line_number += 1
  endwhile

  if a:firstline == a:lastline
     " single line
  else
     execute "normal! gv"
  endif
endfun
