" vim: set sw=4 sts=4 et fdm=marker:

set nocompatible
source $VIMRUNTIME/vimrc_example.vim

" Prettier integration for .js files {{{1
function! s:loadPrettier()
    if exists('g:loaded_prettier')
        return
    endif

    let g:loaded_prettier = 1
    let g:prettier_prg = ''
    let g:prettier_supported_ft = [
        \ 'javascript',
        \ 'javascript.jsx'
    \ ]

    function s:executePrettierOnBuffer()
        let l:cursor = getcurpos()
        silent execute "normal! ggVGgq"
        call setpos('.', l:cursor)
    endfunction

    function s:getProjectRootPath()
        let l:packagejson = findfile('package.json', '.;')
        let l:project_root_path = fnamemodify(l:packagejson, ':p:h')
        return l:project_root_path
    endfunction

    function s:hasLocalPrettier()
        let l:project_root_path = s:getProjectRootPath()
        return executable(l:project_root_path . '/node_modules/.bin/prettier')
    endfunction

    function s:isSupported()
        return index(g:prettier_supported_ft, &filetype) != -1
    endfunction

    function s:configurePrettier()
        if !s:isSupported()
            return
        endif

        let l:project_root_path = s:getProjectRootPath()

        if s:hasLocalPrettier()
            let g:prettier_prg = l:project_root_path . '/node_modules/.bin/prettier'
        else
            " fallback to the default one
            let g:prettier_prg = 'prettier'
        endif

        if executable(g:prettier_prg)
            let &formatprg=g:prettier_prg . ' --stdin --stdin-filepath %'
        endif
    endfunction

    au BufNewFile,BufEnter *.js call s:configurePrettier()

    function s:executePrettierOnFile()
        if !executable(g:prettier_prg)
            return
        endif

        " onsave is disabled by default
        " let g:prettier_onsave = 1

        if !exists('g:prettier_onsave')
            return
        endif

        let l:nlines_before = line('$')
        let l:view = winsaveview()

        " TODO pass the filetype to prettier when devoid of extension
        let l:command=g:prettier_prg . ' --write ' . expand('%:p')
        call system(l:command)

        call execute('edit!', 'silent!')
        call winrestview(l:view)

        let l:difflines = line('$') - l:nlines_before
        call cursor(line('.') + l:difflines, 0)
    endfunction

    au BufWritePost *.js call s:executePrettierOnFile()

    command! Prettier call s:executePrettierOnBuffer()

endfunction
" }}}1

" Custom linting configuration {{{1
if !exists("*SetOneStyle")

    function SetOneStyle()
        call s:loadPrettier()

        let g:ale_linter_aliases = {'less': 'css'}
        let g:ale_linters = { 'javascript': ['eslint'], 'typescript': ['tslint'] }
        let g:ale_fixers = { 'javascript': ['prettier']}
        " let g:ale_fix_on_save = 1
        let g:prettier_onsave = 1

        let g:javascript_plugin_jsdoc = 1

        set shiftwidth=4
        set softtabstop=4
        set tabstop=4
        set cc=80
    endfunction

endif
" }}}1

" Custom linting configuration {{{1
if !exists("*SetTrustpilotStyle")

    function SetTrustpilotStyle()
        " Mainly Python
        set shiftwidth=4
        set softtabstop=4
        set tabstop=4
        set cc=80

        let g:ale_linters = {
          \ 'python': ['pycodestyle'],
          \ 'javascript': ['eslint'],
          \ 'typescript': ['tslint']
        \ }

        let g:ale_fixers = {
         \ 'python': ['black'],
         \ 'javascript': ['prettier']
        \ }

        let g:prettier_onsave = 1
        let g:ale_fix_on_save = 1

        """ Salesforce / SFDX

        " Load syntax on Apex classesfiles
        au BufEnter,BufRead,BufNewFile *.cls set ft=groovy

    endfunction

endif
" }}}1


let s:cpo_save=&cpo
set cpo&vim
let &cpo=s:cpo_save
unlet s:cpo_save

" Commands remapping, conflicting with Emmet
cabbrev E Explore

" Processing
" map <F7> :!c:\processing\processing-java.exe --sketch=%:p:h --output=c:\dump --run --force <CR><CR>
" au BufRead,BufNewFile *.pde     setf java

" On Windows, also use '.vim' instead of 'vimfiles'; this makes
" synchronization across systems easier.
if has('win32') || has('win64')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" Pathogen
" all bundles in ~/.vim/bundles
execute pathogen#infect()

" Customization
set term=xterm
set mouse=a
set ttymouse=xterm
" set nu
set backspace=indent,eol,start
set helplang=En
set history=100
set hlsearch
set incsearch
set t_Co=256
set laststatus=2
set statusline+=%F
behave xterm
colors molokai
syntax on

" Remap Ctrl-click to file navigation
map <C-LeftMouse> <LeftMouse>gf

" Default to 25 lines when Lexplore
let g:netrw_winsize=25

" Base 16 theme
" let base16colorspace=256
" colors base16-default-dark

if has('gui_running')
    set ghr=24 " fix for dwm http://lists.suckless.org/dwm/0904/7846.html
    set guioptions=aegimrLt
    set guifont=Ubuntu\ Mono\ 12
    colors base16-tomorrow-night
endif

" Some terminal color personalization
hi Visual ctermfg=black
hi Search ctermfg=black

" Use shift+arrow to start visual mode
" set keymodel=startsel,stopsel

set ruler
set selectmode=mouse,key
set whichwrap=b,s,<,>,[,]
set selection=inclusive

" Coding style
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set autoindent
set cc=80

filetype indent off

" Enable custom standard linters in JS
let g:ale_linters = { 'javascript': ['eslint'] }
let g:ale_fixers = { 'javascript': ['prettier-eslint'] }
"let g:ale_javascript_prettier_eslint_executable = 'prettier-eslint'

" ctags
" look for tags file up to the root
set tags=tags;/

" Startup
cd ~/Documents

" TODO this cause a bug in the html syntax with netrw
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
" set autochdir
au BufEnter * silent! lcd %:p:h

" Workaround for Karma runner
" https://github.com/karma-runner/karma/issues/199
set backupcopy=yes

" Set knockoutjs extensions
au BufNewFile,BufRead *.ko set filetype=html

" Load syntax on .make files
au BufRead,BufNewFile *.make set ft=make

" Use cssnext syntax for .css file
" au BufNewFile,BufRead *.css set filetype=cssnext

" Disable persistent undo
set noundofile

" Set swap to another directory
set backup
silent execute '!mkdir -p "'.$HOME.'/.vim/tmp"'
silent execute '!rm -f '.$HOME.'/.vim/tmp/*~'
set backupdir=$HOME/.vim/tmp/
set directory=$HOME/.vim/tmp/

" Set pastetoggle
set pastetoggle=<F2>

" Strip trailing whitespace on save
au BufWritePre * :%s/\s\+$//e

" Enable extended JSX syntax in Javascript files
let g:jsx_ext_required = 0

" Reload vim runnable files after saving
au BufWritePost *.vim source %

" Vim multiple cursors
"let g:multi_cursor_use_default_mapping=0
"let g:multi_cursor_next_key='<C-n>'
"let g:multi_cursor_prev_key='<C-m>'
"let g:multi_cursor_skip_key='<C-x>'
"let g:multi_cursor_quit_key='<Esc>'

" Ctrl-p
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\.git/\|node_modules\|bower_components\|venv'
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 'ra'

" Slime
if v:version >= 800
    let g:slime_target='vimterminal'
endif

""" One specific
au BufRead,BufNewFile ~/Documents/one/* call SetOneStyle()

""" Trustpilot specific
au BufRead,BufNewFile ~/Documents/trustpilot/* call SetTrustpilotStyle()

" Ocaml specific
autocmd FileType ocaml setlocal commentstring=(*\ %s\ *)

" Python specific
autocmd FileType python set commentstring=#\%s

""" OSX specific
if has('macunix')
  " colors default
endif


""" Specific color overrides
highlight ColorColumn ctermbg=8





""" Custom shortcuts

" Move lines up/down
nnoremap <C-Down> :m .+1<CR>
nnoremap <C-j> :m .+1<CR>
nnoremap <C-Up> :m .-2<CR>
nnoremap <C-k> :m .-2<CR>

""" Custom functions
command! GetPackageJson execute "edit " . findfile("package.json", ".;")

function! s:setJavaClassPath()
    " has all sources in ./src
    let l:project_root=finddir("src/..", ".;")

    " add resources
    let l:project_resources=finddir("res/", ".;")
    let l:resources_list=globpath(l:project_resources, '*.jar', 0, 1)

    let l:jar_files = ""
    for l:resource in l:resources_list
        let l:jar_files = l:jar_files . ":" . l:resource
    endfor

    let g:ale_java_javac_classpath = l:project_root . ":" . l:jar_files
endfunction

command! SetJavaClasspath call s:setJavaClassPath()

function! SetIncludeExprJS(fname)
    let l:project_node_modules=finddir("node_modules/", ".;")
    let l:module_dir = l:project_node_modules . a:fname

    if filereadable(l:module_dir . "/package.json")
        return l:module_dir
    else
        return ""
    endif
endfunction

set includeexpr=SetIncludeExprJS(v:fname)

command! FoldTests execute "%g/^\\s*it(.* => {/normal! zf%"
