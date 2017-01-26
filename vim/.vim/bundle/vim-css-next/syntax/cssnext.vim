" Vim syntax file
" Language: cssnext
" Maintainer: Daniele Piccone
" Latest Revision: 25 January 2017

if exists("b:current_syntax")
    finish
endif

syn match cssConstant "[\'|\"].*[\'|\"]"
syn match cssVariable "--[a-zA-Z-]\+"
syn match cssFunction "[a-zA-Z]\+(.*)" contains=cssVariable,cssConstant,cssFunction

syn match cssSelector "[\.:#][a-zA-Z0-9-:]\+" contains=cssFunction
syn match cssDeclaration "\s\+[a-ZA-Z]\+:\s+" contains=cssVariable
syn match cssDirective "@[a-zA-Z-]\+"

syn region cssComment start="\/\*" end="\*\/"
syn region cssBlock start="{" end="}" fold transparent contains=cssSelector,cssDirective,cssFunction,cssDeclaration,cssConstant,cssVariable,cssComment

hi def link cssSelector Type
hi def link cssDirective PreProc
hi def link cssFunction Identifier
hi def link cssTagName Identifier
hi def link cssVariable Constant
hi def link cssConstant Constant
hi def link cssComment Comment

let b:current_syntax = "cssnext"
