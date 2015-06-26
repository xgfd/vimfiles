"
" To use it, copy it to
"     for Unix and OS/2:  ~/..vimrc
"	      for Amiga:  s:..vimrc
"  for MS-DOS and Win32:  $VIM\_.vimrc
"	    for OpenVMS:  sys$login:..vimrc

if has("win32")
  se nocompatible
  source $VIMRUNTIME/vimrc_example.vim
  source $VIMRUNTIME/mswin.vim
  behave mswin
endif
"set diffexpr=MyDiff()
"function MyDiff()
"  let opt = '-a --binary '
"  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
"  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
"  let arg1 = v:fname_in
"  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
"  let arg2 = v:fname_new
"  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
"  let arg3 = v:fname_out
"  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
"  let eq = ''
"  if $VIMRUNTIME =~ ' '
"    if &sh =~ '\<cmd'
"      let cmd = '""' . $VIMRUNTIME . '\diff"'
"      let eq = '"'
"    else
"      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
"    endif
"  else
"    let cmd = $VIMRUNTIME . '\diff'
"  endif
"  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
"endfunction



se ch=2		" Make command line two lines high

se mousehide		" Hide the mouse when typing text


" Only do this for Vim version 5.0 and later.
if version >= 500

	" I like highlighting strings inside C comments
	let c_comment_strings=1

	" Switch on syntax highlighting if it wasn't on yet.
	if !exists("syntax_on")
		syntax on
	endif

	" Switch on search pattern highlighting.
	se hlsearch

	" For Win32 version, have "K" lookup the keyword in a help file
	"if has("win32")
	"  let winhelpfile='windows.hlp'
	"  map K :execute "!start winhlp32 -k <cword> " . winhelpfile <CR>
	"endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set apperence
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set extra options when running in GUI mode
if has("gui_running")
    se guioptions-=T
    se guioptions+=e
    se t_Co=256
    se guitablabel=%M\ %t
endif

se guifont=Inconsolata:h19
se number "show line number
se linebreak "wrap lines
se textwidth=0 "no hard wrap
se ruler
"set color scheme
colorscheme molokai
"se background=light
"colorscheme solarized
colorscheme charged-256

"Indentation relevant
se smartindent
se autoindent
se expandtab
se tabstop=2
se softtabstop=2
se shiftwidth=2
"se autochdir


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Auto commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable spellcheck for txt and tex files
au filetype txt,tex setlocal spell spelllang=en_gb
"Fold js on load
au fileType javascript call JavaScriptFold()
"Auto save at focus lost
au FocusLost * silent! wa
"SPARQL syntax
au BufNewFile,BufRead *.sparql setf sparql

"When .vimrc is edited, reload it
au! bufwritepost .vimrc source ~/.vimrc

"Auto save for every n seconds (not supported yet)
"se as=2

"JS format
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"map <c-f> :call JsBeautify()<cr>
" or
au FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for html
au FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
au FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

"Lisp format
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Key mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Set mapleader
let mapleader = ","
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

map <F4> :Errors<CR> "code syntax check, require syntastic

"Fast reloading of the .vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>
"Fast editing of .vimrc in new tab
function! SwitchToBuf(filename)
	"let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
	" find in current tab
	let bufwinnr = bufwinnr(a:filename)
	if bufwinnr != -1
		exec bufwinnr . "wincmd w"
		return
	else
		" find in each tab
		tabfirst
		let tab = 1
		while tab <= tabpagenr("$")
			let bufwinnr = bufwinnr(a:filename)
			if bufwinnr != -1
				exec "normal " . tab . "gt"
				exec bufwinnr . "wincmd w"
				return
			endif
			tabnext
			let tab = tab + 1
		endwhile
		" not exist, new tab
		exec "tabnew " . a:filename
	endif
endfunction

map <silent> <leader>ee :call SwitchToBuf("~/.vimrc")<cr>

"nmap <silent> <F4> :w<CR> :!clisp -i %<CR>
"nmap <silent> <leader>ct :!ctags -R<cr>

"Smart Home
noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'

"insert mode map

imap <silent> <Home> <C-O><Home>

"delimitMate newline
"imap <C-Return> <CR><Esc>O<Tab>

" Open multiple lines (insert empty lines) before or after current line,
" and position cursor in the new space, with at least one blank line
" before and after the cursor.
function! OpenLines(nrlines, dir)
	let nrlines = a:nrlines < 3 ? 3 : a:nrlines
	let start = line('.') + a:dir
	call append(start, repeat([''], nrlines))
	if a:dir < 0
		normal! 2k
	else
		normal! 2j
	endif
endfunction

" Mappings to open multiple lines and enter insert mode.
nnoremap <Leader>o :<C-u>call OpenLines(v:count, 0)<CR>S
nnoremap <Leader>O :<C-u>call OpenLines(v:count, -1)<CR>S

"Gundo 
nnoremap <F2> :GundoToggle<CR>
"Tern shorcuts
map <F3> :TernDef<CR>
"On Win
map <A-r> :TernRename<CR>
"On Mac
map ® :TernRename<CR>
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk
set whichwrap+=h,l "enable going to the pre/next line using h,j

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Miscellaneous
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable omifunc
filetype plugin on
se omnifunc=syntaxcomplete#Complete

" Turn backup off
se nobackup
se encoding=utf-8
"se clipboard=unnamed
"rv
"Use pathogen
call pathogen#infect()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Vim-latex settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat = 'pdf' 
let g:Tex_CompileRule_pdf='pdflatex --synctex=-1 -interaction=nonstopmode $*' 
let g:Tex_ViewRule_pdf='Skim'
let g:Tex_MultipleCompileFormats='pdf' 
"Latex abbr
abbr sp SPARQL
abbr ld Linked Data

"delimitMate settings
let delimitMate_expand_cr = 1
