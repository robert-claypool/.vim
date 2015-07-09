call pathogen#infect()  " Now any plugins can be extracted to a subdirectory under ~/.vim/bundle, and they will be added to the 'runtimepath'

syntax on
set t_Co=256               " enable 256 colors
set background=dark        " this only tells Vim what the terminal's backgound color looks like
set number                 " yay! line numbers
colorscheme desert256

filetype plugin indent on
