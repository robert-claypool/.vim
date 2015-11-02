" Extract plugins to a subdirectory under ~/.vim/bundle, pathogen will add them to the 'runtimepath'
call pathogen#infect()

if &compatible " if not already set
    " Use Vim defaults (easier, more user friendly than vi defaults).
    " This must be first because it changes other options as a side effect.
    set nocompatible
endif

syntax on                      " of course
set hidden                     " hide buffers instead of closing them, http://usevim.com/2012/10/19/vim101-set-hidden/
set vb                         " visual beep, make co-workers happier
set t_Co=256                   " tell Vim that the terminal supports 256 colors
set number                     " yay! line numbers
set cursorline                 " highlight current line
set showmatch                  " briefly jump to the matching brace when you insert one
set incsearch                  " search as characters are typed
set hlsearch                   " highlight matches
set nowrap                     " wrapping is ugly, off by default
set linebreak                  " but if you switch to wrapping, try not to wrap in the middle of words
set ruler                      " show line number, row/column, or whatever is defined by rulerformat
set title                      " show xterm title, does nothing in GVim
set backspace=indent,eol,start " allow the backspace key to erase previously entered text, autoindent, and newlines
set autoindent                 " autocopy the indentation from the previous line
set nrformats=hex              " because I literally never deal with octal, incrementing 06 (CTRL-A) should result in 07
set splitbelow                 " horizontal windows to appear below the old window
set foldcolumn=1               " add some left margin
set encoding=utf8              " the Vim default is Latin-1, yikes! see http://unix.stackexchange.com/a/23414
set history=200                " keep a longer history, 20 is the default
set scrolloff=3                " start scrolling a few lines before the border (more context around the cursor)
set laststatus=2               " always show the status line

" Build our custom statusline
set statusline=
set statusline+=%-3.3n\        " buffer number
set statusline+=%f\            " filename
set statusline+=%h%m%r%w       " status flags
if exists("g:loaded_fugitive") " git info
    set statusline+=%{fugitive#statusline()}
endif
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " file type
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=              " right align the remainder
set statusline+=%-14(%l,%c%V%)  " line, character
set statusline+=%<%P            " file position
set statusline+=\ \             " spacer
set statusline+=%#error#               " switch to error highlighting
set statusline+=%{&paste?'[paste]':''} " warn if &paste is set
set statusline+=%*                     " return to normal highlighting

set background=dark " this only tells Vim what the terminal's backgound color looks like
if has("gui_running")
    colorscheme base16-pop         " http://chriskempson.github.io/base16
    highlight Comment guifg=gray42 " help my poor eyes
else
    colorscheme desert256
endif

set showcmd         " shows the current command hence the leader key for as long as it is active
set timeoutlen=2000 " keep the <leader> active for 2 seconds (default is 1)
let mapleader=","   " backslash is the default, comma is easier
let g:mapleader=","

" Keep <Leader> and <LocalLeader> different to reduce chance of mappings from
" global plugins to clash with mappings for filetype plugins.
" use \\ because we must escape the backslash
let maplocalleader="\\"

if has("spell") " spell checking was added in Vim 7
    set spelllang=en_us
    nnoremap <Leader>ss :setlocal spell!<cr>
    if has('autocmd')
        " turn on by default for files < 10K
        autocmd Filetype * if getfsize(@%) < 10240 | set spell | endif
    endif
endif

if exists('+colorcolumn') " short lines are more readable, so...
    set colorcolumn=80    " add a vertical line-length column at 80 characters
    highlight ColorColumn guibg=coral4 " bold, eh?
endif

" Show special characters
if v:version >= 700
    set list listchars=tab:»-,trail:·,extends:→
endif

if exists('g:loaded_sqlutilities')
    " add mappings for SQLUtilities.vim, mnemonic explanation:
    " s   - sql
    " f   - format
    " cl  - column list
    " cd  - column definition
    " cdt - column datatype
    " cp  - create procedure
    vmap <leader>sf        <Plug>SQLU_Formatter<CR>
    nmap <leader>scl       <Plug>SQLU_CreateColumnList<CR>
    nmap <leader>scd       <Plug>SQLU_GetColumnDef<CR>
    nmap <leader>scdt      <Plug>SQLU_GetColumnDataType<CR>
    nmap <leader>scp       <Plug>SQLU_CreateProcedure<CR>
endif

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/  " credit to http://stackoverflow.com/a/4617156/23566

set wildmenu                   " command line completion, try it with ':color <Tab>'
set wildmode=longest:full,full " complete till the longest common string and start wildmenu, subsequent tabs cycle the menu options

" ignore various binary/compiled/transient files
set wildignore=*.o,*.obj,*~,*.py[cod],*.swp
set wildignore+=*.exe,*.msi,*.dll,*.pdb
set wildignore+=*.png,*.jpg,*.jpeg,*.gif,*.pdf,*.zip,*.7z
set wildignore+=*.mxd,*.msd " Esri ArcGIS stuff
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
else
    set wildignore+=.git\*,.hg\*,.svn\*
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
    filetype plugin indent on " turn on filetype detection and allow loading of language specific indentation files
endif

" expand tabs to spaces by default
" two is the Node.js standard, tabs are the jQuery standard, flame-wars abound, and 4 looks nice to me
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
if has('autocmd')
    " now override with filetype based indentions
    augroup filetype_overrides
        autocmd FileType ruby set softtabstop=2|set shiftwidth=2|set expandtab
        " PEP-8 tells us to use spaces, https://python.org/dev/peps/pep-0008/
        autocmd FileType python set softtabstop=4|set shiftwidth=4|set expandtab|set tabstop=4
    augroup END
endif

" disable arrow keys for navigation, use `hjkl` and love it
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

" <esc> is so so far away, use this `jj` home row sequence instead
" note that comments cannot go after the inoremap (insert no recursion map) sequence
" else they become part of it, thus these comments are above the command itself
inoremap jj <esc>

" nopaste is the default but we set it here explicitly as a reminder that
" setting the 'paste' option will disable other options like inoremap, see :help 'paste'
set nopaste
