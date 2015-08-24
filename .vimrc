call pathogen#infect()          " now any plugins can be extracted to a subdirectory under ~/.vim/bundle, and they will be added to the 'runtimepath'

set vb                          " visual beep, make co-workers happier
syntax on
set t_Co=256                    " tell Vim that the terminal supports 265 colors
set background=dark             " this only tells Vim what the terminal's backgound color looks like
set number                      " yay! line numbers
colorscheme desert256
set cursorline                  " highlight current line
set showmatch                   " briefly jump to the matching brace when you insert one
set incsearch                   " search as characters are typed
set hlsearch                    " highlight matches
set nowrap                      " wrapping is ugly, off by default
set linebreak                   " but if you switch to wrapping, try not to wrap in the middle of words
set ruler                       " show line number, row/column, or whatever is defined by rulerformat
set laststatus=2                " always show the status line
set backspace=indent,eol,start  " allow the backspace key to erase previously entered text, autoindent, and newlines
set autoindent                  " autocopy the indentation from the previous line
set nrformats=hex               " because I literally never deal with octal, incrementing 06 (CTRL-A) should result in 07
set splitbelow                  " horizontal windows to appear below the old window
set foldcolumn=1                " add some left margin
set encoding=utf8               " the Vim default is Latin-1, yikes! see http://unix.stackexchange.com/a/23414

set showcmd                     " shows the current command hence the leader key for as long as it is active
set timeoutlen=2000             " keep the <leader> active for 2 seconds (default is 1)
let mapleader=","               " backslash is the default, comma is easier
let g:mapleader=","

if has("spell")                 " spell checking was added in Vim 7
    set spelllang=en_us
    nnoremap <leader>ss :setlocal spell!<cr>
endif

if exists('+colorcolumn')       " short lines are more readable, so...
    set colorcolumn=80          " add a vertical line-length column at 80 characters
endif

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/   " credit to http://stackoverflow.com/a/4617156/23566

set wildmenu                    " command line completion, try it with ':color <Tab>'
set wildmode=longest:full,full  " complete till the longest common string and start wildmenu, subsequent tabs cycle the menu options

" ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T           " no toolbar
    set guioptions-=r           " no right-side scrollbar
    set guioptions-=e           " no fancy tabs, make them like look like console tabs
endif

" automatically save and load views/folds
if has('autocmd')
    " using a group keeps our autocommands from being defined twice (which can happen when .vimrc is sourced)
    augroup manage_views
        " allow :mkview to save folds, cursor position, etc., but no 'options'
        " because remembering options tends to cause problems.
        set viewoptions-=options
        autocmd BufWritePost *
        \   if expand('%') != '' && &buftype !~ 'nofile'
        \|      mkview
        \|  endif
        autocmd BufRead *
        \   if expand('%') != '' && &buftype !~ 'nofile'
        \|      silent loadview
        \|  endif
    augroup END
endif

" the default viewdir, used by :mkview, is a poor choice on Windows
" change it to a path that won't need Administrator rights to create
if has("win16") || has("win32")
    set viewdir=~/vimfiles/view
endif

" A file type plugin (ftplugin) is a script that is run automatically
" when Vim detects the type of file when as file is created or opened.
" The type can be detected from the file name extension or from the file contents.
if has('autocmd')
    filetype plugin indent on   " turn on filetype detection and allow loading of language specific indentation files
endif
" expand tabs to spaces by default
" two is the Node.js standard, tabs are the jQuery standrd, flame-wars abound, and 4 looks nice to me
set expandtab
set shiftwidth=4
set softtabstop=4
if has('autocmd')
    " now override with filetype based indentions
    augroup filetype_overrides
        autocmd FileType ruby set softtabstop=2|set shiftwidth=2|set expandtab
    augroup END
endif

" disable arrow keys for navigation, use `hjkl` and love it!
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

" never engage Ex mode (make Q harmless)
" http://www.bestofvim.com/tip/leave-ex-mode-good/
nnoremap Q <nop>

" <esc> is too far away, use this home row sequence instead...
" note that comments cannot go after the inoremap (insert no recursion map) sequence
" else they become part of it, thus these comments are above the command itself
inoremap jj <esc>
" nopaste is the default but we set it here explicitly as a reminder that
" setting the 'paste' option will disable other options like inoremap, see :help 'paste'
set nopaste
