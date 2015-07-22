call pathogen#infect()          " Now any plugins can be extracted to a subdirectory under ~/.vim/bundle, and they will be added to the 'runtimepath'

syntax on
set t_Co=256                    " enable 256 colors
set background=dark             " this only tells Vim what the terminal's backgound color looks like
set number                      " yay! line numbers
colorscheme desert256
set cursorline                  " highlight current line
set wildmenu                    " autocomplete for commands, try it with :color <Tab>
set showmatch                   " briefly jump to the matching brace when you insert one
set incsearch                   " search as characters are typed
set hlsearch                    " highlight matches
set nowrap                      " wrapping is ugly, off by default
set ruler                       " show line number, row/column, or whatever is defined by rulerformat
set backspace=indent,eol,start  " allow the backspace key to erase previously entered text, autoindent, and newlines
set autoindent                  " autocopy the indentation from the previous line 
set wildmenu                    " command line completion, try it with ':color <Tab>'
set wildmode=longest:full,full  " complete till the longest common string and start wildmenu, subsequent tabs cycle the menu options

" A file type plugin (ftplugin) is a script that is run automatically when
" Vim detects the type of file when as file is created or opened.
" The type can be detected from the file name extension or from the file contents.
if has('autocmd')
    filetype plugin indent on     " turn on filetype detection and allow loading of language specific indentation files
endif
" expand tabs to spaces by default
" two is the Node.js standard, tabs are the jQuery standrd, flame-wars abound, and 4 looks nice to me
set expandtab 
set shiftwidth=4
set softtabstop=4
if has('autocmd')
    " now override with filetype based indentions
    autocmd FileType ruby set softtabstop=2|set shiftwidth=2|set expandtab
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

" <esc> is too far away, use this home row sequence instead...
" note that comments cannot go after the inoremap (insert no recursion map) sequence
" else they become part of it, thus these comments are above the command itself
inoremap jj <esc>
" nopaste is the default but we set it here explicitly as a reminder that
" setting the 'paste' option will disable other options like inoremap, see :help 'paste'
set nopaste
