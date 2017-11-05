" Author: Ben Reedy <https://github.com/breed808>
" Description: Adds support for the gometalinter suite for Go files

if !exists('g:ale_go_gometalinter_options')
    let g:ale_go_gometalinter_options = ''
endif

function! ale_linters#go#gometalinter#GetCommand(buffer) abort
    return 'gometalinter '
    \   . ale#Var(a:buffer, 'go_gometalinter_options')
    \   . ' ' . shellescape(fnamemodify(bufname(a:buffer), ':p:h'))
endfunction

function! ale_linters#go#gometalinter#GetMatches(lines) abort
    let l:pattern = '\v^([a-zA-Z]?:?[^:]+):(\d+):?(\d+)?:?:?(warning|error):?\s\*?(.+)$'

    return ale#util#GetMatches(a:lines, l:pattern)
endfunction

function! ale_linters#go#gometalinter#Handler(buffer, lines) abort
    let l:output = []

    for l:match in ale_linters#go#gometalinter#GetMatches(a:lines)
        " Omit errors from files other than the one currently open
        if !ale#path#IsBufferPath(a:buffer, l:match[1])
            continue
        endif

        call add(l:output, {
        \   'lnum': l:match[2] + 0,
        \   'col': l:match[3] + 0,
        \   'type': tolower(l:match[4]) ==# 'warning' ? 'W' : 'E',
        \   'text': l:match[5],
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('go', {
\   'name': 'gometalinter',
\   'executable': 'gometalinter',
\   'command_callback': 'ale_linters#go#gometalinter#GetCommand',
\   'callback': 'ale_linters#go#gometalinter#Handler',
\   'lint_file': 1,
\})
