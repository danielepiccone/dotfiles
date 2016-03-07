set nocompatible
source $VIMRUNTIME/vimrc_example.vim

" set diffexpr=MyDiff()
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

" cnoremap <C-F4> c
" inoremap <C-F4> c
" cnoremap <C-Tab> w
" inoremap <C-Tab> w
" cmap <S-Insert> +
" imap <S-Insert> 
" xnoremap  ggVG

" snoremap  gggHG
" onoremap  gggHG
" nnoremap  gggHG
" noremap  
" vnoremap  :update

" nnoremap  :update

" onoremap  :update

" vnoremap  "+x
" noremap  
" noremap  u
" cnoremap  :simalt ~

" inoremap  :simalt ~

" map Q gq
" nmap gx <Plug>NetrwBrowseX
" nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)

" onoremap <C-F4> c
" nnoremap <C-F4> c
" vnoremap <C-F4> c
" onoremap <C-Tab> w
" nnoremap <C-Tab> w
" vnoremap <C-Tab> w
" vmap <S-Insert> 
" vnoremap <BS> d
" vmap <C-Del> "*d
" vnoremap <S-Del> "+x
" vnoremap <C-Insert> "+y
" nmap <S-Insert> "+gP
" omap <S-Insert> "+gP
" cnoremap  gggHG
" inoremap  gggHG
" inoremap  :update

" inoremap  u
" cmap  +
" inoremap  
" inoremap  u
" noremap   :simalt ~

let s:cpo_save=&cpo
set cpo&vim
let &cpo=s:cpo_save
unlet s:cpo_save

" Support clipboard copy/paste
nmap  "+gP
omap  "+gP
vnoremap  "+y

" Commands remapping, conflicting with Emmet
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
    colors darkblue
endif

" Some terminal color personalization
hi Visual ctermfg=black
hi Search ctermfg=black

" Use shift+arrow to start visual mode
" set keymodel=startsel,stopsel

set ruler
" set selection=exclusive
set selectmode=mouse,key
set whichwrap=b,s,<,>,[,]
set sel=inclusive

" Coding style
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

" Less autocompiler
autocmd BufWritePost,FileWritePost *.css.less silent !lessc <afile> <afile>:r

" Coffeescript autocompiler
autocmd BufWritePost,FileWritePost *.js.coffee silent !coffee --print -c <afile> > <afile>:r

" Set knockoutjs extensions
au BufNewFile,BufRead *.ko set filetype=html

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
autocmd BufWritePre * :%s/\s\+$//e

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
    let g:syntastic_javascript_eslint_exec = '/home/dpi/Documents/professional-services/node_modules/.bin/eslint'
endfunction


" Default mapping
"let g:multi_cursor_use_default_mapping=0
"let g:multi_cursor_next_key='<C-n>'
"let g:multi_cursor_prev_key='<C-m>'
"let g:multi_cursor_skip_key='<C-x>'
"let g:multi_cursor_quit_key='<Esc>'

""" Project specific
au BufRead,BufNewFile /home/dpi/Documents/professional-services/* call SetSyntasticEsLint()
