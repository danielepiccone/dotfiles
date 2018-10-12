" vim: set sw=4 sts=4 et fdm=marker:

set nocompatible
source $VIMRUNTIME/vimrc_example.vim

" Prettier integration for .js files {{{1
function! s:loadPrettier()
    if exists('g:loaded_prettier')
        return
    endif

    """ Utils
    function s:replaceBufferContent(new_buffer)
        " remove all buffer content
        silent! execute '%delete _'

        " put the new content
        silent! execute '%put = a:new_buffer'

        " remove extra line at the top
        silent! execute '0delete _'
    endfunction

    function s:getBufferContent()
        return join(getline(1, '$'), "\n")
    endfunction

    function s:executePrettierOnBuffer()
        let l:cursor = getcurpos()
        silent execute "normal! ggVGgq"
        call setpos('.', l:cursor)
    endfunction

    let g:loaded_prettier = v:true
    let g:prettier_prg = ''

    " onsave is disabled by default
    " let g:prettier_onsave = 1

    function s:configurePrettier()
        let l:packagejson = findfile('package.json', '.;')
        let l:project_root_path = fnamemodify(l:packagejson, ':p:h')

        if executable(l:project_root_path . '/node_modules/.bin/prettier')
            let g:prettier_prg = l:project_root_path . '/node_modules/.bin/prettier'
            " enable prettier on save
            let g:prettier_onsave = 1
        else
            " fallback to the default one
            let g:prettier_prg = 'prettier'
        endif

        if executable(g:prettier_prg)
            let &formatprg=g:prettier_prg . ' --stdin --stdin-filepath %'
        endif
    endfunction

    au BufNewFile,BufWinEnter *.js call s:configurePrettier()

    function s:onSave()
        if !executable(g:prettier_prg)
            return
        endif

        if !exists('g:prettier_onsave')
            return
        endif

        " save the cursor pos
        let l:cursor = getcurpos()

        let l:new_buffer = system(g:prettier_prg . " --stdin --stdin-filepath " . expand('%:p'), s:getBufferContent())

        if (v:shell_error == 0)
            call s:replaceBufferContent(l:new_buffer)

            " restore the cursor pos
            call setpos('.', l:cursor)
        endif
    endfunction

    au BufWritePre *.js call s:onSave()

    command! Prettier call s:executePrettierOnBuffer()

endfunction
" }}}1


" Custom linting configuration {{{1
if !exists("*SetOneStyle")

    function SetOneStyle()

        " Syntastic configuration
        "
        " let g:syntastic_javascript_checkers = ['eslint']
        " TODO install eslint-one-configuration globally
        " let g:syntastic_javascript_eslint_exec = '/home/dpi/Documents/one/frontend/node_modules/.bin/eslint'
        " Requires https://stylelint.io/
        " let g:syntastic_less_checkers=['stylelint']
        " Requires https://github.com/gcorne/vim-sass-lint
        " let g:syntastic_sass_checkers=['sasslint']
        " let g:syntastic_scss_checkers=['sasslint']

        let g:ale_linter_aliases = {'less': 'css'}
        let g:ale_linters = { 'javascript': ['eslint'], 'typescript': ['tslint'] }

        let g:javascript_plugin_jsdoc = 1

        set shiftwidth=4
        set softtabstop=4
        set tabstop=4
        set cc=80

        highlight ColorColumn ctermbg=8

        call s:loadPrettier()

    endfunction

endif
" }}}1

let s:cpo_save=&cpo
set cpo&vim
let &cpo=s:cpo_save
unlet s:cpo_save

" Support X / Windows clipboard copy/paste
nmap  "+gP
omap  "+gP
vnoremap  "+y

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
behave xterm
colors molokai
" set nu
set backspace=indent,eol,start
set helplang=En
set history=100
set hlsearch
set incsearch
set t_Co=256
set laststatus=2
set statusline+=%F
set mouse=a

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
filetype indent off

" Enable custom standard linters in JS
let g:syntastic_javascript_checkers = ['standard']
let g:ale_linters = { 'javascript': ['standard'] }
" let g:ale_linters = { 'javascript': ['standard', 'flow'] }
" let g:javascript_plugin_flow = 1

" Startup
cd ~/Documents

" TODO this cause a bug in the html syntax with netrw
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
" set autochdir
au BufEnter * silent! lcd %:p:h

" Workaround for Karma runner
" https://github.com/karma-runner/karma/issues/199
set backupcopy=yes

" Less autocompiler
" au BufWritePost,FileWritePost *.css.less silent !lessc <afile> <afile>:r

" Coffeescript autocompiler
" au BufWritePost,FileWritePost *.js.coffee silent !coffee --print -c <afile> > <afile>:r

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

" Enable Syntastic honor tsconfig.json
" http://stackoverflow.com/questions/34102184/use-tsconfig-json-for-tsc-with-syntastic-in-vim
let g:syntastic_typescript_tsc_fname = ''

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
let g:ctrlp_custom_ignore = '\.git/\|node_modules\|bower_components'
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 'ra'

""" One specific
au BufRead,BufNewFile /home/dpi/Documents/one/* call SetOneStyle()

""" OSX specific
if has('macunix')
  colors default
endif

""" Custom shortcuts

" Move lines up/down
nnoremap <C-Down> :m .+1<CR>
nnoremap <C-j> :m .+1<CR>
nnoremap <C-Up> :m .-2<CR>
nnoremap <C-k> :m .-2<CR>

""" Custom functions
command! GetPackageJson execute "edit " . findfile("package.json", ".;")
