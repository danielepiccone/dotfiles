set nocompatible
source $VIMRUNTIME/vimrc_example.vim

" set diffexpr=MyDiff()

" Custom diff function {{{1
function MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    if $VIMRUNTIME =~ ' '
        if &sh =~ '\<cmd'
            let cmd = '""' . $VIMRUNTIME . '\diff"'
            let eq = '"'
        else
            let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
        endif
    else
        let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction
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
    set guifont=DejaVu\ Sans\ Mono:h10:cANSI
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" Customization
behave xterm
colors default
set nonu
set backspace=indent,eol,start
set helplang=En
set history=100
set hlsearch
set incsearch

if has('gui_running')
    colors desert
    set ghr=0 " fix for dwm http://lists.suckless.org/dwm/0904/7846.html
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
set shiftwidth=4
set softtabstop=4
set tabstop=4
set autoindent
filetype indent off

" Startup
cd ~/Documents

" TODO this cause a bug in the html syntax with netrw
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
" set autochdir
au BufEnter * silent! lcd %:p:h

" Workaround for Karma runner
" https://github.com/karma-runner/karma/issues/199
set backupcopy=yes

" Pathogen
" all bundles in ~/.vim/bundles
execute pathogen#infect()

" Less autocompiler
" au BufWritePost,FileWritePost *.css.less silent !lessc <afile> <afile>:r

" Coffeescript autocompiler
" au BufWritePost,FileWritePost *.js.coffee silent !coffee --print -c <afile> > <afile>:r

" Set knockoutjs extensions
au BufNewFile,BufRead *.ko set filetype=html

" Use cssnext syntax for .css file
au BufNewFile,BufRead *.css set filetype=cssnext

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

" Enable custom standard linters in JS
function SetSyntasticOneLint()
    let g:syntastic_javascript_checkers = ['standard']
    let g:syntastic_javascript_standard_exec = 'onelint'
    let g:syntastic_javascript_standard_generic = 1
endfunction

function SetSyntasticEsLint()
    let g:syntastic_javascript_checkers = ['eslint']
    let g:syntastic_javascript_eslint_exec = '/home/dpi/Documents/taskmate/node_modules/.bin/eslint'
endfunction

" Enable Syntastic honor tsconfig.json
" http://stackoverflow.com/questions/34102184/use-tsconfig-json-for-tsc-with-syntastic-in-vim
let g:syntastic_typescript_tsc_fname = ''

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

""" Project specific
au BufRead,BufNewFile /home/dpi/Documents/taskmate/* call SetSyntasticEsLint()

" vim: set sw=4 sts=4 et fdm=marker:
