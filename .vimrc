call pathogen#infect()     " Now any plugins can be extracted to a subdirectory under ~/.vim/bundle, and they will be added to the 'runtimepath'

syntax on
set t_Co=256               " enable 256 colors
set background=dark        " this only tells Vim what the terminal's backgound color looks like
set number                 " yay! line numbers
colorscheme desert256
set cursorline             " highlight current line
filetype plugin indent on  " turn on filetype detection and allow loading of language specific indentation files
set wildmenu               " autocomplete for commands, try it with :color <Tab>
set showmatch              " briefly jump to the matching brace when you insert one
set incsearch              " search as characters are typed
set hlsearch               " highlight matches
set nowrap                " Wrapping is ugly, off by default
set ruler                 " Show line number, row/column, or whatever is defined by rulerformat

" <esc> is too far away, use this home row sequence instead...
" note that comments cannot go after the inoremap (insert no recursion map) sequence
" else they become part of it, thus these comments are above the command itself
inoremap jj <esc>
" nopaste is the default but we set it here explicitly as a reminder that
" setting the 'paste' option will disable other options like inoremap, see :help 'paste'
set nopaste
