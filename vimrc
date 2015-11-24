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
    "set color scheme
    colorscheme molokai
    "se background=light
    "colorscheme solarized
    colorscheme charged-256
    se guitablabel=%M\ %t
    if has("win32")
      se guifont=Inconsolata:h19
    else
      se guifont=Skyhook\ Mono:h19
    endif
endif

se number "show line number
se linebreak "wrap lines
se textwidth=0 "no hard wrap
se ruler

"fold
se foldmethod=indent

"Indentation relevant
"se smartindent
filetype indent on
se expandtab tabstop=4 softtabstop=4 shiftwidth=4
"se autochdir

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Auto commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable spellcheck for txt and tex files
au filetype txt,tex setlocal spell spelllang=en_gb

"Auto save at focus lost
au FocusLost * silent! wa

"SPARQL syntax
au BufNewFile,BufRead *.sparql setf sparql

"When .vimrc is edited, reload it
au! bufwritepost .vimrc source ~/.vimrc

"Auto save for every n seconds (not supported yet)
"se as=2

"auto format
"au BufWrite * :Autoformat

"rainbow parentheses matching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Key mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Set mapleader
let mapleader = ","
let maplocalleader = ","

"code format
noremap <S-f> :Autoformat<CR>
noremap <C-f> :Autoformat<CR>

"code syntax check, require syntastic
map <F4> :Errors<CR> 

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

"switch to vimrc
map <silent> <leader>ee :call SwitchToBuf("~/.vimrc")<cr>

"nmap <silent> <F4> :w<CR> :!clisp -i %<CR>
"nmap <silent> <leader>ct :!ctags -R<cr>

nmap <F8> :TagbarToggle<CR>

"Smart Home
noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'

"insert mode map
imap <silent> <Home> <C-O><Home>

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
nnoremap <F2> :UndotreeToggle<CR>

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

"fugitive shortcuts for Git
map <leader>gs :Gstatus<CR>
map <leader>gd :Gdiff<CR>
map <leader>gc :Gcommit<CR>
map <leader>gb :Gblame<CR>
map <leader>gl :Glog<CR>
map <leader>gp :Git pull<CR>
map <leader>gps :Git push<CR>

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""vimtex settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("win32")
    let g:vimtex_view_general_viewer = 'SumatraPDF'
    let g:vimtex_view_general_options = '-forward-search @tex @line @pdf'
    let g:vimtex_view_general_options_latexmk = '-reuse-instance'
else
    let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
    let g:vimtex_view_general_options = '@line @pdf @tex'
endif

"Latex abbr
abbr sp SPARQL
abbr ld Linked Data

"delimitMate settings
let delimitMate_expand_cr = 1
