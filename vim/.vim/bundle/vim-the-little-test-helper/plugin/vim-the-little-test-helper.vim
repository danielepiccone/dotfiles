
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

function! s:getProjectRootPath()
  return substitute(finddir('.git', ';'), '.git', '', '')
endfunction

function! s:getCurrentFilePath()
  return substitute(expand('%:p'), expand('%:t'), '', '')
endfunction

function! s:getJestTestsPath()
  return s:getCurrentFilePath() . '__tests__/'
endfunction

function! s:getTestCandidates(fullFileName, paths)
  let l:candidates = []
  let l:pathTokens = split(a:fullFileName, '/')
  let l:fileName = remove(l:pathTokens, len(l:pathTokens) - 1)
  let l:specFile = substitute(fileName,'\.jsx\?$','\.spec.js', '')
  let l:testFile = substitute(fileName,'\.jsx\?$','\.test.js', '')

  for path in a:paths
    call insert(l:candidates, path . l:specFile)
    call insert(l:candidates, path . l:testFile)
    if (path . l:fileName != a:fullFileName)
      call insert(l:candidates, path . l:fileName)
    endif
  endfor

  return l:candidates
endfunction

let s:test = {}
let s:test.candidates = [
  \ '/foo/__tests__/foobar.js',
  \ '/foo/__tests__/foobar.test.js',
  \ '/foo/__tests__/foobar.spec.js',
  \ '/foo/foobar.test.js',
  \ '/foo/foobar.spec.js'
\ ]
call assert_equal(s:getTestCandidates('/foo/foobar.js', ['/foo/', '/foo/__tests__/']), s:test.candidates)
unlet s:test

function! s:tryCandidates(candidates)
  for candidate in a:candidates
    if file_readable(candidate)
      return candidate
    endif
  endfor
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
  let l:paths = []
  let l:found = ''

  call insert(l:paths, s:getCurrentFilePath())
  call insert(l:paths, s:getJestTestsPath())

  if s:isTest(l:fileName)
    " Do nothing
  else
    let l:candidates = s:getTestCandidates(l:fileName, l:paths)
    let l:found = s:tryCandidates(l:candidates)
  endif

  if l:found != ''
    execute 'e ' . l:found
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
