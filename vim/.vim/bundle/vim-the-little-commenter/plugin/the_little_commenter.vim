" The little commenter
" Description: A small plugin to comment/uncomment lines in vim
" Author: Daniele Piccone <mail@danielepiccone.com>

function! s:getCommentBoundaries()
  return split(&commentstring, "%s", 1)
endfunction

function! s:ensureLanguageSupport()
  if len(split(&commentstring, "%s")) > 0
    return 1
  endif
endfunction

function! s:isEmptyString(string)
  return a:string =~ '^\s*$'
endfunction

function! s:toggleComment(line, shouldComment, boundaries, padding)
  let [lboundary, rboundary] = a:boundaries
  if a:shouldComment
    let updatedLine = repeat(' ', a:padding) . lboundary . ' ' . strpart(a:line, a:padding)
    if rboundary != ''
      let updatedLine = substitute(updatedLine, '$', ' ' . rboundary, '')
    endif
  else
    let updatedLine = substitute(a:line, '^\(\s*\)' . escape(lboundary, '*') . '\(\s\{0,1\}\)', '\1', 'g')
    if rboundary != ''
      let updatedLine = substitute(updatedLine, " " . escape(rboundary, '*') . "$", "", "")
    endif
  endif
  return updatedLine
endfunction

function! s:shouldComment(line)
  let [lboundary, rboundary] = s:getCommentBoundaries()
  " TODO this breaks for empty lines with only the comment boundary
  " eg: //
  return !(a:line =~ '^\s*'. escape(lboundary, '*'))
endfunction

function! s:getLinePadding(line)
    return strlen(matchstr(a:line, '^\s*'))
endfunction

function! s:getMinLinePadding(lines)
  if (len(a:lines) == 1) && (s:isEmptyString(a:lines[0]))
    return 0
  endif
  let minPadding = 999
  for line in a:lines
    if s:isEmptyString(line)
      continue
    endif
    let padding = s:getLinePadding(line)
    if padding < minPadding
      let minPadding = padding
    endif
  endfor
  return minPadding
endfunction

function! ToggleComments() range
  if !s:ensureLanguageSupport()
    return
  endif

  let lineNumber = a:firstline
  let shouldComment = s:shouldComment(getline(getcurpos()[1]))
  let minLinePadding = s:getMinLinePadding(getline(a:firstline, a:lastline))
  let commentBoundaries = s:getCommentBoundaries()

  while lineNumber <= a:lastline
    let line = getline(lineNumber)
    let updatedLine = s:toggleComment(line, shouldComment, commentBoundaries, minLinePadding)
    call setline(lineNumber, updatedLine)
    let lineNumber += 1
  endwhile

  if a:firstline == a:lastline
     " single line
  else
     execute "normal! gv"
  endif
endfunction

" ==============================================================================
" Test
" ==============================================================================
let v:errors = []

let s:test = {}
if &ft == 'vim'
  let s:test.boundaries = ['"', '']
  call assert_equal(s:toggleComment('foobar', v:true, s:test.boundaries, 0), '" foobar')
  call assert_equal(s:toggleComment('  foobar', v:true, s:test.boundaries, 2), '  " foobar')
  call assert_equal(s:toggleComment('" foobar', v:false, s:test.boundaries, 0), 'foobar')
  call assert_equal(s:toggleComment('  " foobar', v:false, s:test.boundaries, 0), '  foobar')
  call assert_equal(s:toggleComment('"', v:false, s:test.boundaries, 0), '')
  call assert_equal(s:toggleComment('"', v:false, s:test.boundaries, 2), '')

  let s:test.boundaries = ['<', '>']
  call assert_equal(s:toggleComment('foobar', v:true, s:test.boundaries, 0), '< foobar >')
  call assert_equal(s:toggleComment('  foobar', v:true, s:test.boundaries, 2), '  < foobar >')
  call assert_equal(s:toggleComment('< foobar >', v:false, s:test.boundaries, 0), 'foobar')
  call assert_equal(s:toggleComment('  < foobar >', v:false, s:test.boundaries, 0), '  foobar')

  call assert_equal(s:shouldComment('foobar'), 1)
  call assert_equal(s:shouldComment('" foobar'), 0)
  call assert_equal(s:shouldComment('  foobar'), 1)
  call assert_equal(s:shouldComment('  " foobar'), 0)

  let s:test.lines = []
  call add(s:test.lines, '   foobar')
  call add(s:test.lines, '')
  call add(s:test.lines, '  foobar')
  call assert_equal(s:getMinLinePadding(s:test.lines), 2)
  call add(s:test.lines, ' foobar')
  call assert_equal(s:getMinLinePadding(s:test.lines), 1)
  call add(s:test.lines, 'foobar')
  call assert_equal(s:getMinLinePadding(s:test.lines), 0)

  let s:test.lines = []
  call add(s:test.lines, '')
  call assert_equal(s:getMinLinePadding(s:test.lines), 0)

endif
unlet s:test

if (len(v:errors) > 0)
  echo v:errors
endif

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

