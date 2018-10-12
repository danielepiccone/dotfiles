
" Priority
" .spec
" .test
" ../__test__/
"
"

" if exists('g:loaded_the_little_test_helper')
"   finish
" endif
" let g:loaded_the_little_test_helper = 1
let v:errors = []

" TODO
" the order of the candidates in these functions must be the same
" with the first one (the last inserted is the first one (shift))
" being the easiest and the last one the hardest

function! s:findTestFoldersInProject()
  " get the project path
  " :set wildignore+=*/node_modules/*
  " echo finddir('test', '**', '4')
endfunction

function! s:getTestCandidates(fullFileName)
  let l:candidates = []

  let l:pathTokens = split(a:fullFileName, '/')
  let l:fileName = remove(l:pathTokens, len(l:pathTokens) - 1)

  let l:specFile = substitute(fileName,'\.jsx\?$','\.spec.js', '')
  let l:testFile = substitute(fileName,'\.jsx\?$','\.test.js', '')
  let l:testFolderFile = substitute(fileName,'\(.*\)\.\(jsx\?\)$','__tests__/\1\.js', '')
  let l:testFolderTestFile = substitute(fileName,'\(.*\)\.\(jsx\?\)$','__tests__/\1\.test.js', '')

  call insert(l:candidates, l:testFolderTestFile)
  call insert(l:candidates, l:testFolderFile)
  call insert(l:candidates, l:testFile)
  call insert(l:candidates, l:specFile)

  return l:candidates
endfunction

let s:test = {}
let s:test.candidates = [
  \ 'foobar.spec.js',
  \ 'foobar.test.js',
  \ '__tests__/foobar.js',
  \ '__tests__/foobar.test.js'
\ ]
call assert_equal(s:getTestCandidates('/foo/foobar.js'), s:test.candidates)
unlet s:test

function! s:getSubjectCandidates(fullFileName)
  let l:candidates = []

  let l:pathTokens = split(a:fullFileName, '/')
  let l:fileName = remove(l:pathTokens, len(l:pathTokens) - 1)

  " remove test and spec and file from the extension
  let l:testOrSpecRe = '\.\(test\|spec\)\.js$'
  if matchstr(l:fileName, l:testOrSpecRe) != ''
    call insert(l:candidates, substitute(l:fileName, l:testOrSpecRe, '.js', ''))
  endif

  return l:candidates
endfunction

" TODO this should return the whole path to allow __test__  ?
"call assert_equal(s:getSubjectCandidates('/foo/__test__/foobar.test.js'), ['../foobar.js'])
"call assert_equal(s:getSubjectCandidates('/foo/__test__/foobar.test.js'), ['../foobar.js'])
call assert_equal(s:getSubjectCandidates('/foo/foobar.test.js'), ['foobar.js'])
call assert_equal(s:getSubjectCandidates('/foo/foobar.spec.js'), ['foobar.js'])

function! s:tryCandidates(candidates)
  for candidate in a:candidates
    if file_readable(candidate)
      return candidate
    endif
  endfor
endfunction

function! s:getProjectRoot()
  return substitute(finddir('.git', ';'), '/.git', '', '')
endfunction

function! s:isTest(fileName)
  if matchstr(a:fileName, '\.spec\.js$') != ''
    return 1
  endif

  if matchstr(a:fileName, '\.test\.js$') != ''
    return 1
  endif
endfunction

call assert_equal(s:isTest('/foo/bar/foo.spec.js'), 1)
call assert_equal(s:isTest('/foo/bar/foo.test.js'), 1)
call assert_equal(s:isTest('foo.spec.js'), 1)
call assert_equal(s:isTest('foo.test.js'), 1)
call assert_equal(s:isTest('/foo/bar/foo.js'), 0)
call assert_equal(s:isTest('foo.js'), 0)

function! ToggleTests()
  let l:fileName = expand('%:p')
  " TODO find tests starting from the root /test
  " let l:rootPath = s:getProjectRoot()

  if s:isTest(l:fileName)
    let l:candidates = s:getSubjectCandidates(l:fileName)
    let l:found = s:tryCandidates(l:candidates)
  else
    let l:candidates = s:getTestCandidates(l:fileName)
    let l:found = s:tryCandidates(l:candidates)
  endif

  if l:found != ''
    execute 'open ' . l:found
  endif
endfunction

command! GetTests call ToggleTests()
nmap gs :call ToggleTests()<cr>

" ==============================================================================
" Test
" ==============================================================================

if (len(v:errors) > 0)
  echo v:errors
endif
