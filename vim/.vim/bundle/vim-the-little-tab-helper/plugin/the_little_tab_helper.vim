" The little tab helper
" Description: Custom tabline for Gvim omitting index.* filenames
" Author: Daniele Piccone <mail@danielepiccone.com>

let s:DIRECTORY_SEPARATOR = '/'

function! s:formatFileName(fileName)
  let fragments = split(a:fileName, s:DIRECTORY_SEPARATOR)
  let fragmentsNo = len(fragments)

  if fragmentsNo == 0
    return '[No Name]'
  endif

  if fragmentsNo == 1
    return fragments[0]
  endif

  if fragmentsNo > 1
    let lastFragment = fragments[fragmentsNo - 1]
    let parentFragment = fragments[fragmentsNo - 2]

    " transform index files to =>ext
    if fnamemodify(lastFragment, ':r') == 'index'
      let lastFragment = '➔' . fnamemodify(lastFragment, ':e')
    endif

    return '...' . parentFragment . s:DIRECTORY_SEPARATOR . lastFragment
  endif
endfunction

function! LittleTabHelperGetTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let fileName = fnamemodify(bufname(buflist[winnr - 1]), ':p')
  return s:formatFileName(fileName)
endfunction

function! LittleTabHelper()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{LittleTabHelperGetTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999X[X]'
  endif

  return s
endfunction

if has('gui_running')
  function! LittleTabHelperGUI()
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
endif

" ==============================================================================
" Test
" ==============================================================================
let v:errors = []

let s:test = {}
if &ft == 'vim'
  call assert_equal(s:formatFileName('foobar'), 'foobar')
  call assert_equal(s:formatFileName('~/foobar/bazbar/foobaz/bar.js'), '...foobaz/bar.js')
  call assert_equal(s:formatFileName('~/foobar/bazbar/foobaz/index.ext'), '...foobaz/➔ext')
endif
unlet s:test

if (len(v:errors) > 0)
  echo v:errors
endif

" ==============================================================================
" Initialize
" ==============================================================================

if exists("g:loaded_the_little_tab_helper")
  finish
endif
let g:loaded_the_little_tab_helper = 1

set tabline=%!LittleTabHelper()

if has('gui_running')
  set guitablabel=%{LittleTabHelperGUI()}
endif
