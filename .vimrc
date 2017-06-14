" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []

" Changes Plugin requires Vim 8
if v:version < '800'
    call add(g:pathogen_disabled, 'changesPlugin')
endif

" Gundo requires at least Vim 7.3
if v:version < '703' || !has('python')
    call add(g:pathogen_disabled, 'gundo')
endif

if has('win16') || has('win32')
    " Plugins will not load unless you have created the special ~/vimfiles folder, see .gitignore and README.md.
    if !empty(glob('~/vimfiles/autoload/pathogen.vim'))
        " Extract plugins to a subdirectory under ~/.vim/bundle, pathogen will add them to the 'runtimepath'.
        call pathogen#infect()
    else
        echoerr "Plugins were not loaded. Please setup '~/vimfiles', see README.md"
    endif
else
    " Must be Mac/Linux.
    if !empty(glob('~/.vim/autoload/pathogen.vim'))
        call pathogen#infect()
    else
        echoerr "Plugins were not loaded. Please setup '~\.vim', see README.md"
    endif
endif

if &compatible " if not already set
    " Use Vim defaults (easier, more user friendly than vi defaults).
    " This must be first because it changes other options as a side effect.
    set nocompatible
endif

" It's OK to have an unwritten buffer that's no longer visible.
" See http://usevim.com/2012/10/19/vim101-set-hidden/
" Vim keeps us safe from quitting altogether while having unwritten buffers,
" so there's no chance of accidentally losing data.
" Reminders:
"   1. Edit multiple buffers using :bufdo
"   2. Use :wa to write all
set hidden

" Remove ALL autocommands to prevent them from being loaded twice.
if has('autocmd')
    autocmd!
endif

if has('syntax')
    syntax on " of course
endif

" Set Vim-specific sequences for RGB 24-bit colors.
" This works in xterm when $TERM is 'xterm-256color'
" and in termite when $TERM is 'xterm-termite'
" and in tmux when $TERM is 'screen-256color'
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

set t_Co=256                   " tell Vim that the terminal supports 256 colors
set t_ut=                      " Disable Background Color Erase for Tmux + Vim. http://superuser.com/a/562423
set vb                         " visual beep, make co-workers happier
set cursorline                 " highlight current line
set showmatch                  " briefly jump to the matching brace when you insert one
set incsearch                  " search as characters are typed
set ignorecase                 " ignore case when searching
set smartcase                  " ignore case if search pattern is all lowercase
set hlsearch                   " highlight matches
set nowrap                     " wrapping is ugly, off by default
set linebreak                  " but if you switch to wrapping, try not to wrap in the middle of words
set ruler                      " show line number, row/column, or whatever is defined by rulerformat
set title                      " show xterm title, does nothing in GVim
set backspace=indent,eol,start " allow the backspace key to erase previously entered text, autoindent, and newlines
set autoindent                 " autocopy the indentation from the previous line
set nrformats=hex              " because I literally never deal with octal, incrementing 06 (CTRL-A) should result in 07
set foldcolumn=1               " add some left margin
set encoding=utf8              " the Vim default is Latin-1, yikes! see http://unix.stackexchange.com/a/23414
set history=500                " keep a longer history, 20 is the default
set scrolloff=5                " start scrolling a few lines before the border (more context around the cursor)
set sidescrolloff=3            " don't scroll any closer to the left or right
set laststatus=2               " always show the status line
set showmode                   " this is default for Vim, set here as a reminder
set autoread                   " auto reload files changed outside of Vim
set synmaxcol=600              " limit syntax highlighing

" Open new split panes to the right and bottom, which feels more natural.
set splitbelow
set splitright

set showcmd " shows the current command hence the leader key for as long as it is active

" Time out on mapping after 2 seconds, time out on key codes after 100ms.
" See ':help timeoutlen' and tpope/sensible-vim
set timeout timeoutlen=2000 ttimeoutlen=100

let mapleader="," " backslash is the default, comma is easier
let g:mapleader=","

" Keep <Leader> and <LocalLeader> different to reduce chance of mappings from
" global plugins to clash with mappings for filetype plugins.
" Use \\ because we must escape the backslash.
let maplocalleader="\\"

nnoremap <localleader>ev :vsplit $MYVIMRC<cr>| " mnemonic = 'e'dit my 'v'imrc file

if !has('clipboard')
    echom "The +clipboard feature was not found."
endif

" Make Y move like D and C.
" By default Y copies the whole line.
noremap Y y$

" Easier yank into CLIPBOARD:
vnoremap <localleader>yy "+y
vnoremap <localleader>YY "+Y
nnoremap <localleader>yy <nop>| " <nop> because it's useless to 'y' with nothing selected
nnoremap <localleader>YY "+Y

if has('X11')
    " Easier yank into PRIMARY:
    vnoremap <localleader>y* "*y
    vnoremap <localleader>Y* "*Y
    nnoremap <localleader>y* <nop>| " <nop> because it's useless to 'y' with nothing selected
    nnoremap <localleader>Y* "*Y
endif

" Easier paste into CLIPBOARD:
nnoremap <localleader>pp "+p
nnoremap <localleader>PP "+P
vnoremap <localleader>pp "+p
vnoremap <localleader>PP "+P

set number " use NumberToggle() for standard line numbers... see below.
if &diff
    set relativenumber! " no relative numbers when diffing
    set number
endif
set diffopt+=vertical " vertical splits for the files to diff

function! NumberToggle()
  if(&relativenumber == 1)
    set relativenumber!
    set number
  else
    set relativenumber " for seeing jump distances 12j or 13j, 8k or 9k
    set number!
  endif
endfunc
nnoremap <localleader>nt :call NumberToggle()<cr>

" We use ww and qq because Vim will wait timeoutlen if there is only one w or q.
nnoremap <localleader>ww :w<cr>|  " faster save
nnoremap <localleader>qq :q<cr>|  " faster quit
nnoremap <localleader>wq :wq<cr>| " faster save and quit

" Windows splits
nnoremap <localleader>ws <C-w>s|  " split window horizontally
nnoremap <localleader>wv <C-w>v|  " split window vertically

" Windows management
nnoremap <localleader>wh <C-w>h|  " align window LEFT of others
nnoremap <localleader>wj <C-w>j|  " align window BELOW others
nnoremap <localleader>wk <C-w>k|  " align window ABOVE others
nnoremap <localleader>wl <C-w>l|  " align window RIGHT of others

" Windows navigation
nnoremap <localleader>hh <C-w>h|  " jump cursor, window to the LEFT
nnoremap <localleader>jj <C-w>j|  " jump cursor, window to the BELOW
nnoremap <localleader>kk <C-w>k|  " jump cursor, window to the ABOVE
nnoremap <localleader>ll <C-w>l|  " jump cursor, window to the RIGHT

" Quickly cycle through open buffers.
" nnoremap <C-n> :bnext<cr>
" nnoremap <C-p> :bprevious<cr>|  " this overwrites CtrlP

" Cycle and then show a list of the buffers.
" The current buffer will be marked with a '#'.
nnoremap <A-n> :bnext<cr>:redraw<cr>:ls<cr>
nnoremap <A-p> :bprevious<cr>:redraw<cr>:ls<cr>

" Beautify JSON with Python.
" https://docs.python.org/3/library/json.html#json-commandline
" Since = is the Vim operator to format a selected text, I'm using it here.
nnoremap <localleader>=j :%!python -m json.tool<cr>

" Remove all trailing whitespace.
" http://vi.stackexchange.com/a/2285/4919
" Mnemonic for the sequence is 'd'elete 'w'hite 's'pace.
nnoremap <localleader>dws :let _s=@/<bar>:%s/\s\+$//e<bar>:let @/=_s<bar><cr>
" Alternatively, we can auto-trim whitespace with .editorconfig trim_trailing_whitespace.

" While NerdTree plugin is installed, vim-vinegar triggers it by default.
" If for some reason that's not working, uncomment the next line:
" let NERDTreeHijackNetrw=1
" See http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/
" And https://www.reddit.com/r/vim/comments/22ztqp/why_does_nerdtree_exist_whats_wrong_with_netrw/

if has('spell') " spell checking was added in Vim 7
    set spelllang=en_us
    set spellsuggest=best,10 " show only the top 10
    nnoremap <localleader>ss :setlocal spell!<bar>:echo "Use vim-unimapired [os and ]os instead."<cr>
    if has('autocmd')
        " turn on by default for files < 20K
        autocmd Filetype * if getfsize(@%) < 20480 | set spell | endif
    endif
endif

" Show special characters.
if v:version >= 700
    " To see carriage returns as ^M, reopen the DOS-formatted file as Unix:
    " :e ++fileformat=unix
    " Vim hides carriage returns when the format is Unix and I don't think
    " there's any way around that except to change the format to DOS.
    set list listchars=tab:»-,trail:·,extends:→,eol:$
    nnoremap <localleader>st :set list!<cr>| " mnemonic is 's'pecial 't'oggle
endif

" These line wrap settings look better if number or relativenumber are on.
set cpoptions+=n     " start line wrapping in the line-number area.
set showbreak=-->\ | " keep a space between \ and |

if v:version >= 703
    " The default 'zip' cryptmethod is weak.
    " 7.3 added blowfish which is stronger.
    " More at :help encryption
    set cryptmethod=blowfish
endif

" Whitespace and color column highlighting are wrapped in a functions because
" we need to call them when the colorscheme is changed
" (which happens a lot, see mode_yo below).
function! WhoaWhitespace(color)
    exe 'highlight ExtraWhitespace ctermbg='.a:color.' guibg='.a:color
    match ExtraWhitespace /\s\+$/ " credit to http://stackoverflow.com/a/4617156/23566
endfunction

function! WhoaTypos(fg,bg)
    " So this is a weird one...
    " I tend to typo an A on the end of lines because I so frequently
    " get into INSERT mode trying to use the A key mapping (append at EOL).
    " If I'm already in INSERT mode, then the A key stroke is a typo.
    exe 'highlight MyTypos ctermfg='.a:fg.' ctermbg='.a:bg.' guifg='.a:fg.' guibg='.a:bg
    syntax match MyTypos /A$/ containedin=ALL
    " The A at the end of this line should be highlighted... A
    syntax match MyTypos /:w$/ containedin=ALL
    " The :w at the end of this line should be highlighted... :w
endfunction

" Autofix these typos.
iabbrev teh the
iabbrev Teh The

function! WhoaColorColumn(bg)
    if exists('+colorcolumn') " short lines are more readable, so...
        " add a vertical line-length column at 79 characters
        " 79 is from https://www.python.org/dev/peps/pep-0008/#maximum-line-length
        set colorcolumn=79
        exe 'highlight ColorColumn guibg='.a:bg
    endif
endfunction

function! PostThemeSettings()
    " Here we run stuff that must be applied after the theme has changed.
    call WhoaWhitespace('red')
    call WhoaTypos('black','yellow')
    if exists('g:loaded_airline')
        exe 'AirlineRefresh'
    endif
endfunction

set background=dark " this only tells Vim what the terminal's background color looks like

if has('win16') || has('win32')
  let g:PaperColor_Theme_Options = {
    \   'theme': {
    \     'default.dark': {
    \       'transparent_background': 0
    \     }
    \   }
    \ }
else
  let g:PaperColor_Theme_Options = {
    \   'theme': {
    \     'default.dark': {
    \       'transparent_background': 1
    \     }
    \   }
    \ }
endif
colorscheme PaperColor
call PostThemeSettings()
call WhoaColorColumn('#222222')

if has('autocmd')
    " Automatically save and load views/folds...

    " Using groups keeps our autocommands from being defined twice (which can happen when .vimrc is sourced)
    augroup manage_views
        " Clear the autocmds of the current group to prevent them from piling
        " up each time we reload vimrc.
        autocmd!

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
       augroup mode_yo
           " Clear the autocmds of the current group to prevent them from piling
           " up each time we reload vimrc.
           autocmd!

           autocmd InsertEnter * call PostThemeSettings()
           autocmd InsertEnter * call WhoaColorColumn('#330066')
           autocmd InsertLeave * call PostThemeSettings()
           autocmd InsertLeave * call WhoaColorColumn('#222222')
       augroup END
    endif
endif

" Command line completion, try it with ':color <Tab>'.
set wildmenu
" Complete till the longest common string and start wildmenu, subsequent tabs cycle the menu options.
set wildmode=longest:full,full
" Ignore various binary/compiled/transient files.
set wildignore=*.o,*.obj,*~,*.py[cod],*.swp
set wildignore+=*.exe,*.msi,*.dll,*.pdb
set wildignore+=*.png,*.jpg,*.jpeg,*.gif,*.pdf,*.zip,*.7z
set wildignore+=*.mxd,*.msd " Esri ArcGIS stuff
if has('win16') || has('win32')
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" Set backup/swap/undo/view files to the proper folders.
if has('win16') || has('win32')
    " Vim backups are just a failsafe. Most files are already in source control.
    " Here we use our special ~/vimfiles folder, see .gitignore and README.md.
    " The double tailing slash tells Vim to store files using full paths,
    " thus if you edit multiple foo.txt files, they won't clobber your backups.
    set backupdir=~/vimfiles/vim-backups//
    set directory=~/vimfiles/vim-swaps//
    " Undo files allow us to use undos after exiting and restarting Vim.
    " This is only present in 7.3+, see :help undo-persistence
    if exists('+undofile')
        set undodir=~/vimfiles/vim-undos//
    endif
    " The default viewdir, used by :mkview, is a poor choice on Windows,
    " vimfiles/ is a path that won't need Administrator rights.
    set viewdir=~/vimfiles/vim-views//
else
    " Mac/Linux
    set backupdir=~/.vim/vim-backups//
    set directory=~/.vim/vim-swaps//
    if exists('+undofile')
        set undodir=~/.vim/vim-undos//
    endif
    set viewdir=~/.vim/vim-views//
endif

" ~ is the default extension, use .bak instead.
set backupext=.bak
exe 'set wildignore+=*' . &backupext
set backup

if exists('+undofile')
    set undolevels=500   " muchos levels of undo
    set undoreload=10000 " max lines to save for undo on a buffer reload
    set undofile
endif

set modeline    " allow files to specify vim options
set modelines=3 " check the top 3 lines

" A file type plugin (ftplugin) is a script that is run automatically
" when Vim detects the type of file when as file is created or opened.
" The type can be detected from the file name extension or from the file contents.
if has('autocmd')
    filetype plugin indent on " turn on filetype detection and allow loading of language specific indentation files
    augroup my_filetypes
        " Clear the autocmds of the current group to prevent them from piling
        " up each time we reload vimrc.
        autocmd!

        autocmd BufNewFile,BufRead config set filetype=config
        autocmd BufNewFile,BufRead nginx*.conf set filetype=nginx
        autocmd BufNewFile,BufRead *.server set filetype=javascript
        autocmd BufNewFile,BufRead *.js.* set filetype=javascript
        autocmd BufNewFile,BufRead *.json.* set filetype=javascript
        autocmd BufNewFile,BufRead *.config set filetype=javascript
        autocmd BufNewFile,BufRead *.{jshintrc,eshintrc,jscsrc} set filetype=javascript
        autocmd BufNewFile,BufRead db.config set filetype=xml
        autocmd BufNewFile,BufRead Web.config set filetype=xml
        " Vim detects md files as modula2, except for README.md. Fix that.
        autocmd BufNewFile,BufReadPost *.{md,markdown} set filetype=markdown
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
        " Clear the autocmds of the current group to prevent them from piling
        " up each time we reload vimrc.
        autocmd!

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

" We default to LF line endings for new files.
" http://vim.wikia.com/wiki/Change_end-of-line_format_for_dos-mac-unix
" 1. This will not change the format of existing files, use dos2unix for that.
" 2. You can override line endings to be CR or CRLF on a per-project basis by
" adding an EditorConfig with 'cr' or 'crlf' as the end_of_line.
" EditorConfig settings will take priority as long as the plugin is working.
set fileformat=unix
set fileformats=unix,dos

" Specify additional HTML tags to auto indent.
let g:html_indent_inctags='html,body,head,tbody'
" Indent after <script> and <style> tags too.
let g:html_indent_script1='inc'
let g:html_indent_style1='inc'

" Disable arrow keys for navigation, use `hjkl` and love it.
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>
noremap  <up>    <nop>
noremap  <down>  <nop>
noremap  <left>  <nop>
noremap  <right> <nop>

" Dance faster!
nnoremap <c-j> jjjjj
nnoremap <c-k> kkkkk

" Better line jumping with wrapped lines.
" See https://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Typo hitting F1 will open "help" when you probably just wanted to get out of insert mode, fix that.
inoremap <f1> <esc>

" ; repeats the last f/F/ t/T search
" If you don't care about that, then make ; an alias for <shift>;
" nnoremap ; :

if v:version >= 704 && has('patch235')
    " ; gets stuck on a t command, but this was fixed in 7.3.235
    " Make sure we allow the fix (don't use compatibility mode for ;)
    " http://stackoverflow.com/a/15669344
    set cpo-=;
endif

" In insert mode, pressing Ctrl-u deletes text you've typed in t
" current line, and Ctrl-w deletes the word before the cursor.
" You can't undo these deletions! Fix that.
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Make <space> in normal mode add a space.
nnoremap <space> i<space><esc>l

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

" Enable quick switching of "paste mode".
set pastetoggle=<f2>

" Quickly reload the file.
noremap <f3> :edit<cr>

" Build our custom status line.
" None of this matters if you are using vim-airline, which you should.
set statusline=
set statusline+=%-3.3n\        " buffer number
set statusline+=%f\            " filename
set statusline+=%h%m%r%w       " status flags
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

" https://github.com/Netherdrake/Dotfiles, <localleader>h[1-6]
function! HiInterestingWord(n)
    " Save our location.
    normal! mz
    " Yank the current word into the z register.
    normal! "zyiw
    " Calculate an arbitrary match ID. Hopefully nothing else is using it.
    let mid = 86750 + a:n
    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)
    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'
    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)
    " Move back to our original location.
    normal! `z
endfunction

nnoremap <localleader>h0 :call clearmatches()<cr>:noh<cr>
nnoremap <silent> <localleader>h1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <localleader>h2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <localleader>h3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <localleader>h4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <localleader>h5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <localleader>h6 :call HiInterestingWord(6)<cr>

highlight def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
highlight def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
highlight def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
highlight def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
highlight def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
highlight def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

" Potential lag fix, https://redd.it/1p0e46
let g:matchparen_insert_timeout=5

" I assume that Airline exists because setting these on VimEnter does not
" work as well (the tabline does not appear)...
if !exists('g:airline_symbols')
    let g:airline_symbols={}
endif
let g:airline_theme='powerlineish'
" Enable powerline fonts if you have them installed.
" https://powerline.readthedocs.org/en/master/installation.html
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#empty_message='no .git'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#whitespace#enabled=1
let g:airline#extensions#syntastic#enabled=1
let g:airline#extensions#tabline#tab_nr_type=1 " unique number for each tab

" Author: Tim Dahlin
" Description: Opens all quickfix files into whatever is the active split.
function! QuickFixOpenAll()
    if empty(getqflist())
        return
    endif
    let s:prev_val = ""
    for d in getqflist()
        let s:curr_val = bufname(d.bufnr)
        if (s:curr_val != s:prev_val)
            exec "edit " . s:curr_val
        endif
        let s:prev_val = s:curr_val
    endfor
endfunction
" You might want to use :cdo if it's in your build
" https://github.com/vim/vim/commit/aa23b379421aa214e6543b06c974594a25799b09
command! Coa call QuickFixOpenAll()

function! HighlightPosition(blinktime)
    highlight RedOnRed ctermfg=red ctermbg=red guifg=red guibg=red
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    echo matchlen
    let ring_pat = (lnum > 1 ? '\%'.(lnum-1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.\|' : '')
                \ . '\%'.lnum.'l\%>'.max([col-4,1]) .'v\%<'.col.'v.'
                \ . '\|'
                \ . '\%'.lnum.'l\%>'.max([col+matchlen-1,1]) .'v\%<'.(col+matchlen+3).'v.'
                \ . '\|'
                \ . '\%'.(lnum+1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.'
    let ring = matchadd('RedOnRed', ring_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction

" We wrap the N n mappings in a function to call it on VimEnter.
" Something is overwriting them if we don't.
function! Nn()
    " Keep search matches in the middle of the window:
    " zz scrolls the cursor to center
    " zv opens just enough folds to make that line not folded
    " nnoremap n nzzzv
    " nnoremap N Nzzzv

    " This rewires n and N to do some fancy highlighting.
    " h/t https://github.com/greg0ire/more-instantly-better-vim
    nnoremap <silent> n nzzzv:call HighlightPosition(0.2)<cr>
    nnoremap <silent> N Nzzzv:call HighlightPosition(0.2)<cr>
endfunction

if has('autocmd')
    augroup nn_setup
        " Clear the autocmds of the current group to prevent them from piling
        " up each time we reload vimrc.
        autocmd!
        autocmd VimEnter * call Nn()
    augroup END
endif

function! SetPluginOptions()

    if exists('g:loaded_sqlutilities')
        echom "Configuring SQL Utilities..."
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

    if executable('ag')
        " * (super star) searches the CURRENT buffer for the word under your cursor
        " bind \* to search ALL OPEN AND SAVED buffers. This will not find changes
        " in modified buffers, since Ag can only find what is on disk.
        nnoremap <localleader>* :AgBuffer <c-r><c-w><cr>

        " Use ag over grep, we extract the column as well as the file and line number.
        set grepprg=ag\ --nogroup\ --nocolor\ --column

        if exists('g:loaded_ctrlp')
            echom "Configuring CtrlP for Ag..."
            " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
            let g:ctrlp_user_command='ag %s --files-with-matches --nocolor -g ""'
            " ag is fast enough that CtrlP doesn't need to cache
            let g:ctrlp_use_caching=0
        endif
    endif

    if has('win32')
        if exists('g:loaded_EditorConfig')
            echom "Configuring Editor Config..."
            " Vim uses an external EditorConfig Core library to parse .editorconfig
            " files and pass back the properties that should be used.
            let ecpath=expand('~').'\\vimfiles\\lib\\editorconfig-0.12.0-Windows-AMD64.exe'
            if filereadable(ecpath)
                let g:EditorConfig_exec_path=ecpath
                " Ensure that this plugin works well with vim-fugitive.
                let g:EditorConfig_exclude_patterns=['fugitive://.*']
            endif
        endif
    endif

    if exists('g:loaded_syntastic_plugin')
        echom "Configuring Syntastic..."
        " These are recommended by the Syntastic README
        let g:syntastic_always_populate_loc_list=1
        let g:syntastic_loc_list_height=5
        let g:syntastic_auto_loc_list=1
        let g:syntastic_check_on_open=1
        let g:syntastic_check_on_wq=0
        " Passive for scss because Jekyll front matter is not stripped off
        " by Syntastic before sending it to Sass. Maybe I'll fix this with
        " a custom SyntasticMake preprocess function... someday.
        let g:syntastic_mode_map={
            \ "mode": "active",
            \ "active_filetypes": [],
            \ "passive_filetypes": ["scss"] }

        nnoremap <localleader>s? :SyntasticInfo<cr>
        nnoremap <localleader>sc :SyntasticCheck<cr>
    endif

    if exists('g:loaded_gundo')
        echom "Configuring Gundo..."
        let g:gundo_width=65
        let g:gundo_preview_height=15
        nnoremap <localleader>uu :GundoToggle<cr>
        if !has('python')
            echom "Warning: Gundo requires Vim to be compiled with Python 2.4+"
        endif
    endif

    if exists('g:loaded_indent_guides')
        echom "Configuring Indent Guides..."
        " For plugin nathanaelkane/vim-indent-guides
        let g:indent_guides_start_level=2
        let g:indent_guides_guide_size=1
        let g:indent_guides_enable_on_vim_startup=1
    endif

    if exists('g:loaded_startify')
        echom "Configuring Startify..."
        let g:startify_change_to_vcs_root=1
        let g:startify_custom_header = [
            \ '            __',
            \ '    __  __ /\_\    ___ ___',
            \ '   /\ \/\ \\/\ \ /'' __` __`\',
            \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \',
            \ '    \ \___/  \ \_\ \_\ \_\ \_\',
            \ '     \/__/    \/_/\/_/\/_/\/_/',
            \ ]
        " Startify menu is "home"
        nnoremap <localleader>hm :Startify<cr>
    endif

    if exists('g:loaded_rainbow_parentheses')
        echom "Configuring Rainbow Parentheses..."
        autocmd FileType json,javascript,css,html RainbowParenthesesActivate
        autocmd Syntax javascript RainbowParenthesesLoadRound
        autocmd Syntax json,javascript RainbowParenthesesLoadSquare
        autocmd Syntax json,javascript,css RainbowParenthesesLoadBraces
        autocmd Syntax html RainbowParenthesesLoadChevrons
    endif

    echom "Ready."
endfunction

if has('autocmd')
    augroup plugin_setup
        " Clear the autocmds of the current group to prevent them from piling
        " up each time we reload vimrc.
        autocmd!

        " Let man pages appear in the active Vim window and split
        if has('autocmd')
            autocmd VimEnter * echom "Use :Man a_program to open the man page for a_program, e.g. :Man mkdir"
        endif
        runtime! ftplugin/man.vim

        " Plugins are loaded *after* Vim has finished processing .vimrc,
        " so we test for their existence and do stuff on VimEnter.
        autocmd VimEnter * call SetPluginOptions()
    augroup END
endif

" Keep this last.
set secure
