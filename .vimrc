" Extract plugins to a subdirectory under ~/.vim/bundle, pathogen will add them to the 'runtimepath'.
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
set ignorecase                 " ignore case when searching
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

" Build our custom status line.
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

set showcmd         " shows the current command hence the leader key for as long as it is active
set timeoutlen=2000 " keep the <leader> active for 2 seconds (default is 1)
let mapleader=","   " backslash is the default, comma is easier
let g:mapleader=","

" Keep <Leader> and <LocalLeader> different to reduce chance of mappings from
" global plugins to clash with mappings for filetype plugins.
" Use \\ because we must escape the backslash.
let maplocalleader="\\"

" We use ww and qq because Vim will wait timeoutlen if there is only one w or q.
nnoremap <localleader>ww :w<cr>|  " faster save
nnoremap <localleader>qq :q<cr>|  " faster quit
nnoremap <localleader>wq :wq<cr>| " faster quit and save

" Beautify JSON with Python.
" https://docs.python.org/3/library/json.html#json-commandline
" Since = is the Vim operator to format a selected text, I'm using it here.
nnoremap <localleader>=j :%!python -m json.tool<cr>

" Remove all trailing whitespace.
" http://vi.stackexchange.com/a/2285/4919
nnoremap <localleader>dws :let _s=@/<bar>:%s/\s\+$//e<bar>:let @/=_s<bar><cr>

if has("spell") " spell checking was added in Vim 7
    set spelllang=en_us
    nnoremap <localleader>ss :setlocal spell!<cr>
    if has('autocmd')
        " turn on by default for files < 10K
        autocmd Filetype * if getfsize(@%) < 10240 | set spell | endif
    endif
endif

" Show special characters.
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
    vmap <localleader>sf   <plug>SQLU_Formatter<cr>
    nmap <localleader>scl  <plug>SQLU_CreateColumnList<cr>
    nmap <localleader>scd  <plug>SQLU_GetColumnDef<cr>
    nmap <localleader>scdt <plug>SQLU_GetColumnDataType<cr>
    nmap <localleader>scp  <plug>SQLU_CreateProcedure<cr>
endif

set wildmenu                   " command line completion, try it with ':color <Tab>'
set wildmode=longest:full,full " complete till the longest common string and start wildmenu, subsequent tabs cycle the menu options

" Ignore various binary/compiled/transient files.
set wildignore=*.o,*.obj,*~,*.py[cod],*.swp
set wildignore+=*.exe,*.msi,*.dll,*.pdb
set wildignore+=*.png,*.jpg,*.jpeg,*.gif,*.pdf,*.zip,*.7z
set wildignore+=*.mxd,*.msd " Esri ArcGIS stuff
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" Whitespace and color column highlighting are wrapped in a functions because
" we need to call them when the colorscheme is changed
" (which happens a lot, see mode_yo below).
function! WhoaWhitespace(color)
    exe 'highlight ExtraWhitespace ctermbg='.a:color.' guibg='.a:color
    match ExtraWhitespace /\s\+$/ " credit to http://stackoverflow.com/a/4617156/23566
endfunction

function! WhoaColorColumn(color)
    if exists('+colorcolumn') " short lines are more readable, so...
        " add a vertical line-length column at 79 characters
        " 79 is from https://www.python.org/dev/peps/pep-0008/#maximum-line-length
        set colorcolumn=79
        exe 'highlight ColorColumn guibg='.a:color
    endif
endfunction

set background=dark " this only tells Vim what the terminal's backgound color looks like
if has("gui_running")
    colorscheme base16-pop         " http://chriskempson.github.io/base16
    highlight Comment guifg=gray42 " help my poor eyes
    call WhoaWhitespace("red")
    call WhoaColorColumn("coral4") " bold, eh?
else
    colorscheme desert256
endif

if has('autocmd')
    " Automatically save and load views/folds...

    " Using groups keeps our autocommands from being defined twice (which can happen when .vimrc is sourced)
    augroup manage_views
        " Allow :mkview to save folds, cursor position, etc., but no 'options'
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

    " Let's make it obvious if I'm in insert mode.
    if version >= 700
        if has("gui_running")
            augroup mode_yo
                autocmd InsertEnter * colorscheme base16-eighties
                autocmd InsertEnter * call WhoaWhitespace("red")
                autocmd InsertEnter * call WhoaColorColumn("DarkOliveGreen3")
                autocmd InsertLeave * colorscheme base16-pop
                autocmd InsertLeave * call WhoaWhitespace("red")
                autocmd InsertLeave * call WhoaColorColumn("coral4")
            augroup END
        endif
    endif
endif

" The default viewdir, used by :mkview, is a poor choice on Windows,
" change it to a path that won't need Administrator rights to create.
if has("win16") || has("win32")
    set viewdir=~/vimfiles/view
endif

" A file type plugin (ftplugin) is a script that is run automatically
" when Vim detects the type of file when as file is created or opened.
" The type can be detected from the file name extension or from the file contents.
if has('autocmd')
    filetype plugin indent on " turn on filetype detection and allow loading of language specific indentation files
    augroup my_filetypes
        autocmd BufNewFile,BufRead *.server set filetype=javascript
        autocmd BufNewFile,BufRead *.js.* set filetype=javascript
        autocmd BufNewFile,BufRead *.json.* set filetype=javascript
        autocmd BufNewFile,BufRead *.config set filetype=javascript
        autocmd BufNewFile,BufRead db.config set filetype=xml
        autocmd BufNewFile,BufRead Web.config set filetype=xml
    augroup END
endif

" Expand tabs to spaces by default.
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4
if has('autocmd')
    " now override with filetype based indentions
    augroup filetype_overrides
        " Two is the Node.js standard, https://github.com/nodejs/node/blob/master/.eslintrc#L46
        " Tabs are the jQuery standard, FYI. Node wins here.
        autocmd FileType javascript setlocal softtabstop=2|setlocal shiftwidth=2|setlocal expandtab
        autocmd FileType html       setlocal softtabstop=2|setlocal shiftwidth=2|setlocal expandtab
        autocmd FileType css        setlocal softtabstop=2|setlocal shiftwidth=2|setlocal expandtab
        " The unofficial Ruby style guide: http://www.caliban.org/ruby/rubyguide.shtml#indentation
        autocmd FileType ruby       setlocal softtabstop=2|setlocal shiftwidth=2|setlocal expandtab
        " PEP-8 tells us to use spaces, https://python.org/dev/peps/pep-0008/
        autocmd FileType python     setlocal softtabstop=4|setlocal shiftwidth=4|setlocal expandtab|setlocal tabstop=4
    augroup END
endif

if has("win32")
    " Vim uses an external EditorConfig Core library to parse .editorconfig
    " files and pass back the properties that should be used.
    let ecpath = expand("~")."\\vimfiles\\lib\\editorconfig-0.12.0-Windows-AMD64.exe"
    if filereadable(ecpath)
        let g:EditorConfig_exec_path = ecpath
        " Ensure that this plugin works well with vim-fugitive.
        let g:EditorConfig_exclude_patterns = ['fugitive://.*']
    endif
endif

" We default to LF line endings for new files.
" http://vim.wikia.com/wiki/Change_end-of-line_format_for_dos-mac-unix
" 1. This will not change the format of existing files, use dos2unix for that.
" 2. You can override line endings to be CR or CRLF on a per-project basis by
" adding an EditorConfig with 'cr' or 'crlf' as the end_of_line.
" EditorConfig settings will take priority as long as the plugin is working.
set fileformat=unix
set fileformats=unix,dos

" Specify additional HTML tags to auto indent.
let g:html_indent_inctags = "html,body,head,tbody"
" Indent after <script> and <style> tags too.
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" Disable arrow keys for navigation, use `hjkl` and love it.
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>
noremap  <up>    <nop>
noremap  <down>  <nop>
noremap  <left>  <nop>
noremap  <right> <nop>

" Typo hitting F1 will open "help" when you probably just wanted to get out of insert mode, fix that.
inoremap <f1> <esc>

" Have dedicated tab switchers.
inoremap <f7> gT
inoremap <f8> gt
noremap  <f7> gT
noremap  <f8> gt

" Never engage Ex mode (make Q harmless).
" http://www.bestofvim.com/tip/leave-ex-mode-good/
nnoremap Q <nop>

" <Esc> is so so far away, use this `jj` home row sequence instead.
" Note that comments cannot go after the inoremap (insert no recursion map) sequence
" else they become part of it, thus these comments are above the command itself.
inoremap jj <esc>

" nopaste is the default but we set it here explicitly as a reminder that
" setting the 'paste' option will disable other options like inoremap, see :help 'paste'
set nopaste
