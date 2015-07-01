" .vimrc file imported from gvim/mswin
set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
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

version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
cnoremap <C-F4> c
inoremap <C-F4> c
cnoremap <C-Tab> w
inoremap <C-Tab> w
cmap <S-Insert> +
imap <S-Insert> 
xnoremap  ggVG
snoremap  gggHG
onoremap  gggHG
nnoremap  gggHG
vnoremap  "+y
noremap  
vnoremap  :update

nnoremap  :update

onoremap  :update

nmap  "+gP
omap  "+gP
vnoremap  "+x
noremap  
noremap  u
cnoremap   :simalt ~

inoremap   :simalt ~

map Q gq
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)

onoremap <C-F4> c
nnoremap <C-F4> c
vnoremap <C-F4> c
onoremap <C-Tab> w
nnoremap <C-Tab> w
vnoremap <C-Tab> w
vmap <S-Insert> 
vnoremap <BS> d
vmap <C-Del> "*d
vnoremap <S-Del> "+x
vnoremap <C-Insert> "+y
nmap <S-Insert> "+gP
omap <S-Insert> "+gP
cnoremap  gggHG
inoremap  gggHG
inoremap  :update

inoremap  u
cmap  +
inoremap  
inoremap  u
noremap   :simalt ~

let &cpo=s:cpo_save
unlet s:cpo_save
set background=dark
set backspace=indent,eol,start
set backup
set diffexpr=MyDiff()
set helplang=En
set history=50
set hlsearch
set incsearch
set keymodel=startsel,stopsel
set ruler
" set selection=exclusive
set selectmode=mouse,key
set whichwrap=b,s,<,>,[,]
set sel=inclusive

" Commands remapping
cabbrev E Explore

" Compiler
map <F5> :silent SCCompileRun<CR>
imap <F5> <Esc>:silent SCCompileRun<CR>
map <F4> :<Up><CR>
imap <F4> <Esc>:<Up><CR>
map <F6> :SCCompileRun<CR>
imap <F6> <Esc>:SCCompileRun<CR>

" Processing
" map <F7> :!c:\processing\processing-java.exe --sketch=%:p:h --output=c:\dump --run --force <CR><CR>
" au BufRead,BufNewFile *.pde     setf java

" Gui
set guifont=Ubuntu\ Mono\ 13

" On Windows, also use '.vim' instead of 'vimfiles'; this makes
" synchronization
" across (heterogeneous) systems easier.
if has('win32') || has('win64')
    set guifont=DejaVu\ Sans\ Mono:h10:cANSI
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" Customization, for cygwin/mintty
colors molokai
behave xterm
set nu
set nobackup
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Startup
cd ~/Documents

" TODO this cause a bug in the html syntax with netrw
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
" set autochdir 
autocmd BufEnter * silent! lcd %:p:h

" Workaround for Karma runner
" https://github.com/karma-runner/karma/issues/199
set backupcopy=yes

" Pathogen
" all bundles in ~/.vim/bundles
execute pathogen#infect()

""" Less autocompiler
autocmd BufWritePost,FileWritePost *.css.less silent !lessc <afile> <afile>:r

""" Coffeescript autocompiler
autocmd BufWritePost,FileWritePost *.js.coffee silent !coffee --print -c <afile> > <afile>:r

""" Set knockoutjs extensions
au BufNewFile,BufRead *.ko set filetype=html
