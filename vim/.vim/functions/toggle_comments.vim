" if exists() ...

fun! ToggleLineComment(line_number, lcomment_token)
  let line = getline(a:line_number)

  if (line =~ "^\s*" . a:lcomment_token)
    let changes = substitute(line, a:lcomment_token . " ", "", "")
    call setline(a:line_number, changes)
  else
    let changes = substitute(line, "^", a:lcomment_token . " ", "")
    call setline(a:line_number, changes)
  endif
endfun

fun! ToggleComments() range
  let file_type = &ft
  let lcomment_token = ""

  if (file_type =~ "^javascript")
    let lcomment_token = "\/\/"
  endif

  if (file_type =~ "^vim")
    let lcomment_token = "\""
  endif

  let line_number = a:firstline

  while line_number <= a:lastline
    call ToggleLineComment(line_number, lcomment_token)
    let line_number += 1
  endwhile
endfun
