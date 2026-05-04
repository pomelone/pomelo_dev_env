" see vim option-list
set nocompatible   " not compatible vi option
set noerrorbells   " disable the error bells

set encoding=utf-8   " encoding used internally
set mouse=a   " enable the use of mouse clicks

" allow backspace over something
"   - indent: autoindent
"   - eol: line breaks
"   - start: the start of insert
"   - nostop: like start, do not stop at the start of insert
set backspace=indent,start,eol


map e <Nop>
let mapleader="e"
" esc
inoremap jk <Esc>
" Ctrl-v
noremap <Leader>v <C-v>
noremap <C-e> <C-v>
inoremap <C-e> <C-v>
cnoremap <C-e> <C-v>
" complete
inoremap <C-l> <C-n>
" file edit
noremap fw :wq<Enter>
inoremap fw <Esc>:wq<Enter>
noremap fq :q<Enter>
inoremap fq <Esc>:q<Enter>
" edit
noremap U <C-r>
"noremap U :redo<Enter>
noremap H :nohl<Enter>
noremap L :set number! relativenumber!<Enter>
noremap <C-b> :setlocal wrap!<Enter>
inoremap <C-b> <Esc>:setlocal wrap!<Enter>i
noremap J gj
noremap K gk
" paste
set pastetoggle=<F10>
noremap <C-y> :setlocal paste!<Enter>
inoremap <C-y> <Esc>:setlocal paste!<Enter>i
" window
nnoremap sv :vsplit 
nnoremap sh :split 
nnoremap sf :sfind 
nnoremap wn <C-w>w
nnoremap wp <C-w>W
nnoremap wj <C-w>j
nnoremap wk <C-w>k
nnoremap wh <C-w>h
nnoremap wl <C-w>l
nnoremap wmn <C-w>r
nnoremap wmp <C-w>R
" tabpage
nnoremap st :tabnew 
nnoremap tq :tabclose<Enter>
nnoremap tn :+tabnext<Enter>
nnoremap tp :-tabnext<Enter>
nnoremap tmn :+tabmove<Enter>
nnoremap tmp :-tabmove<Enter>


if &term=~"xterm"
    if has("terminfo")
        set t_Co=8
        set t_Sf=[3%p1%dm
        set t_Sb=[4%p1%dm
    else
        set t_Co=8
        set t_Sf=[3%dm
        set t_Sb=[4%dm
    endif
endif


" open & display
set laststatus=2   " tells when last window has status lines, 2: always
set ruler   " display the cursor position in the lower right corner
set showcmd   " display an incomplete command in the lower right corner
set cmdheight=1   " number of screen lines to use for the command-lin
set showmode   " message on status line to show current mode
set number   " display line number
set relativenumber " show the line number relative to the line with the cursor in front of each line
set nowrap   " disable long lines wrap and continue on the next line
set cursorline   " highlight the screen line of the cursor
hi CursorLine term=bold,underline cterm=bold ctermfg=NONE ctermbg=DarkGrey gui=bold guifg=NONE guibg=DarkGrey
hi CursorLineNr term=bold,underline cterm=bold ctermfg=Yellow ctermbg=DarkGrey gui=bold guifg=Yellow guibg=DarkGrey
"set list  " show <Tab> and <EOL>
filetype plugin indent on   " enable filetype detection, using filetype plugin files, using indent files
syntax enable   " enable syntax highlighting, actually execute :source $VIMRUNTIME/syntax/syntax.vim
"syntax on   " overrule your settings with the defaults of syntax highlighting


" statusline
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'i'  : 'Insert',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '' : 'S·Block',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'ce' : 'Ex',
    \ 'cv' : 'Vim Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}
hi User1 cterm=bold ctermfg=Black ctermbg=White gui=bold guifg=Black guibg=White
hi User2 cterm=bold ctermfg=Black ctermbg=Green gui=bold guifg=Black guibg=Green
set statusline=
"set statusline+=%2*[%n]                                      " buffer number
set statusline+=%2*\ %{g:currentmode[mode()]}\                " vim mode
set statusline+=%1*\ %<%F                                     " path to the file in the buffer
set statusline+=%1*\ %=[%{&ff}                                " file format (dos<CR><NL>/unix<NL>/mac<CR>)
set statusline+=%1*\|%{&fenc!=''?&fenc:&enc}                  " file encoding
set statusline+=%1*\|%Y]                                      " file type
set statusline+=%1*\ %m%r%h%w                                 " modifiable?readonly?helpfile?preview?
set statusline+=%2*\ (%l/%L,                                  " line number / number of lines in buffer
set statusline+=%2*%c)                                        " column number
set statusline+=%2*\ %P\                                      " percentage through file of displayed


" view
set splitbelow   " new window from split is below the current one
set splitright   " new window is put right of the current one
set scrolloff=1   " minimum number of lines above and below cursor
set sidescroll=2   " minimum number of columns to scroll horizontal
set sidescrolloff=1   " minimum number of columns to left and right of cursor


" search
set magic   " changes special characters in search patterns
set noignorecase   " case sensitive
set nowrapscan   " stop the search at the start/end of the file
set hlsearch   " highlight all matches
set incsearch   " display the match for the string while you are still typing it


" select
set selection=inclusive   " inclusive: the last character of the selection is included in an operation.
set selectmode=mouse,key   " when to use Select mode instead of Visual mode


" edit
set nopaste
set autoread   " automatically read it when a file have been changed outside
set noautowriteall   " disable auto write the contents of the file
set smartindent   " do smart autoindenting when starting a new line
set autoindent   " use the indent of the previous line for a newly created line
set shiftwidth=4   " number of spaces to use for (auto)indent step
set smarttab   " use 'shiftwidth' when inserting <Tab>
set softtabstop=4   " number of spaces that <Tab> uses while editing
set tabstop=4   " number of spaces that <Tab> in file uses
set expandtab   " use spaces when <Tab> is inserted
set showmatch   " briefly jump to matching bracket if insert one
set completeopt=menuone,preview,longest  " code completion option
set pumheight=20   " maximum height of the popup menu
"set textwidth=80   " maximum width of text that is being inserted


" save & backup
set confirm   " ask what to do about unsaved/read-only files
"set undofile   " save undo information in a file
set undolevels=1000   " maximum number of changes that can be undo;
set swapfile   " whether to use a swapfile for a buffer
set nobackup   " make a backup before overwriting a file


" commands
set history=5000   " keep 500 commands and 500 search patterns in the history
set wildmenu   " use menu for command line completion [enable wildmenu, statusline may not been auto-changed]
set wildmode=full   "  mode for 'wildchar' command-line expansion
