" Plugins will not load unless you have created the special ~/vimfiles folder, see .gitignore and README.md.
if !empty(glob('~/vimfiles/autoload/pathogen.vim'))
    " Extract plugins to a subdirectory under ~/.vim/bundle, pathogen will add them to the 'runtimepath'.
    call pathogen#infect()
else
    echoerr "Plugins were not loaded. Please setup '~/vimfiles', see README.md"
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
"   2. Use :wq to write all
set hidden

" Remove ALL autocommands to prevent them from being loaded twice.
if has('autocmd')
  autocmd!
endif

if has('syntax')
    syntax on " of course
endif

set vb                         " visual beep, make co-workers happier
set t_Co=256                   " tell Vim that the terminal supports 256 colors
set relativenumber             " use NumberToggle() for standard line numbers... see below.
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
set undolevels=500             " muchos levels of undo
set scrolloff=5                " start scrolling a few lines before the border (more context around the cursor)
set sidescrolloff=3            " don't scroll any closer to the left or right
set laststatus=2               " always show the status line
set showmode                   " this is default for Vim, set here as a reminder
set autoread                   " auto reload files changed outside of Vim

" Don't try to syntax highlight huge lines.
set synmaxcol=500

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
nnoremap <localleader>ws <C-W>s|  " split window horizontally
nnoremap <localleader>wv <C-W>v|  " split window vertically

" Windows management
nnoremap <localleader>wh <C-W>h|  " align window LEFT of others
nnoremap <localleader>wj <C-W>j|  " align window BELOW others
nnoremap <localleader>wk <C-W>k|  " align window ABOVE others
nnoremap <localleader>wl <C-W>l|  " align window RIGHT of others

" Windows navigation
nnoremap <localleader>hh <C-W>h|  " jump cursor, window to the LEFT
nnoremap <localleader>jj <C-W>j|  " jump cursor, window to the BELOW
nnoremap <localleader>kk <C-W>k|  " jump cursor, window to the ABOVE
nnoremap <localleader>ll <C-W>l|  " jump cursor, window to the RIGHT

" Beautify JSON with Python.
" https://docs.python.org/3/library/json.html#json-commandline
" Since = is the Vim operator to format a selected text, I'm using it here.
nnoremap <localleader>=j :%!python -m json.tool<cr>

" Remove all trailing whitespace.
" http://vi.stackexchange.com/a/2285/4919
" Mnemonic for the sequence is 'd'elete 'w'hite 's'pace.
nnoremap <localleader>dws :let _s=@/<bar>:%s/\s\+$//e<bar>:let @/=_s<bar><cr>

" While NerdTree plugin is installed, vim-vinegar triggers it by default.
" If for some reason that's not working, uncomment the next line:
" let NERDTreeHijackNetrw=1
" See http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/
" And https://www.reddit.com/r/vim/comments/22ztqp/why_does_nerdtree_exist_whats_wrong_with_netrw/

if has('spell') " spell checking was added in Vim 7
    set spelllang=en_us
    set spellsuggest=best,10 " show only the top 10
    nnoremap <localleader>ss :setlocal spell!<cr>
    if has('autocmd')
        " turn on by default for files < 20K
        autocmd Filetype * if getfsize(@%) < 20480 | set spell | endif
    endif
endif

" Show special characters.
if v:version >= 700
    set list listchars=tab:»-,trail:·,extends:→
endif

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

function! WhoaColorColumn(fg,bg)
    if exists('+colorcolumn') " short lines are more readable, so...
        " add a vertical line-length column at 79 characters
        " 79 is from https://www.python.org/dev/peps/pep-0008/#maximum-line-length
        set colorcolumn=79
        exe 'highlight ColorColumn guifg='.a:fg.' guibg='.a:bg
    endif
endfunction

function! TweakBase16()
    " Override the diff-mode highlights of base16.
    " See comments on https://github.com/chriskempson/base16-vim/commit/2606f91
    highlight DiffAdd    term=bold ctermfg=0 ctermbg=2 guifg=#2b2b2b guibg=#a5c261
    highlight DiffDelete term=bold ctermfg=0 ctermbg=1 gui=bold guifg=#2b2b2b guibg=#da4939
    highlight DiffChange term=bold ctermfg=0 ctermbg=4 guifg=#2b2b2b guibg=#6d9cbe
    highlight DiffText   term=reverse cterm=bold ctermfg=0 ctermbg=4 gui=bold guifg=#2b2b2b guibg=#6d9cbe
    " And this helps my poor eyes
    highlight Comment guifg=gray42
endfunction

function! PostThemeSettings()
    " Here we run stuff that must be applied after the theme has changed.
    call TweakBase16()
    call WhoaWhitespace('red')
    call WhoaTypos('black','yellow')
    if exists('g:loaded_airline')
        exe 'AirlineRefresh'
    endif
endfunction

set background=dark " this only tells Vim what the terminal's background color looks like

if has('gui_running')
    colorscheme base16-railscasts " http://chriskempson.github.io/base16
    call PostThemeSettings()
    call WhoaColorColumn('black','coral4') " bold, eh?
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
        if has('gui_running')
            if !exists('g:very_visual_mode_switching')
                " Normally our InsertEnter/InsertLeave commands are fine, but
                " Vim Multiple Cursors needs to temporarily disable them.
                let g:very_visual_mode_switching = 1
            endif
            augroup mode_yo
                autocmd InsertEnter * if g:very_visual_mode_switching | colorscheme base16-flat | endif
                autocmd InsertEnter * if g:very_visual_mode_switching | call PostThemeSettings() | endif
                autocmd InsertEnter * if g:very_visual_mode_switching | call WhoaColorColumn('black','DarkOliveGreen3') | endif
                autocmd InsertLeave * if g:very_visual_mode_switching | colorscheme base16-railscasts | endif
                autocmd InsertLeave * if g:very_visual_mode_switching | call PostThemeSettings() | endif
                autocmd InsertLeave * if g:very_visual_mode_switching | call WhoaColorColumn('black','coral4') | endif
            augroup END
        endif
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

" I'm wrapping all this in a Windows check until I have time to test on Linux.
if has('win16') || has('win32')
    " Vim backups are just a failsafe. Most files are already in source control.
    " Here we use our special ~/vimfiles folder, see .gitignore and README.md.
    " The double tailing slash tells Vim to store files using full paths,
    " thus if you edit multiple foo.txt files, they won't clobber your backups.
    set backupdir=~/vimfiles/vim-backups//
    " ~ is the default extension, use .bak instead.
    set backupext=.bak
    exe 'set wildignore+=*' . &backupext
    set backup

    " Swap files go under vimfiles too.
    set directory=~/vimfiles/vim-swaps//

    " Undo files allow us to use undos after exiting and restarting Vim.
    " This is only present in 7.3+, see :help undo-persistence
    if exists('+undofile')
        " Like swaps and backups, they go under vimfiles.
        set undodir=~/vimfiles/vim-undos//
        set undolevels=500   " muchos levels of undo
        set undoreload=10000 " max lines to save for undo on a buffer reload
        set undofile
    endif

    " The default viewdir, used by :mkview, is a poor choice on Windows,
    " vimfiles/ is a path that won't need Administrator rights.
    set viewdir=~/vimfiles/vim-views//
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

" Typo hitting F1 will open "help" when you probably just wanted to get out of insert mode, fix that.
inoremap <f1> <esc>

" ; repeats the last f/F/ t/T search
" If you don't care about that, then make ; an alias for <shift>;
" nnoremap ; :

" In insert mode, pressing Ctrl-u deletes text you've typed in t
" current line, and Ctrl-w deletes the word before the cursor.
" You can't undo these deletions! Fix that.
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Make <space> in normal mode add a space.
nnoremap <space> i<space><esc>l

" Keep search matches in the middle of the window:
" zz scrolls the cursor to center
" zv opens just enough folds to make that line not folded
nnoremap n nzzzv
nnoremap N Nzzzv

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

" Enable quick switching of "paste mode"
set pastetoggle=<F2>

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
    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
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

nnoremap <localleader>h0 :call clearmatches()<CR>:noh<CR>
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
let g:airline_theme='molokai'
" Enable powerline fonts if you have them installed.
" https://powerline.readthedocs.org/en/master/installation.html
" let g:airline_powerline_fonts=1
let g:airline#extensions#branch#empty_message='no .git'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#whitespace#enabled=1
let g:airline#extensions#syntastic#enabled=1
let g:airline#extensions#tabline#tab_nr_type=1 " unique number for each tab

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

        if exists('g:loaded_ctrlp')
            echom "Configuring CtrlP..."
            " ag is fast enough that CtrlP doesn't need to cache
            let g:ctrlp_use_caching = 0
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
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 0
    endif

    if exists('g:loaded_gundo')
        echom "Configuring Gundo..."
        let g:gundo_width = 65
        let g:gundo_preview_height = 15
        nnoremap <localleader>uu :GundoToggle<cr>
    endif

    if exists('g:loaded_indent_guides')
        echom "Configuring Indent Guides..."
        " For plugin nathanaelkane/vim-indent-guides
        let g:indent_guides_start_level=2
        let g:indent_guides_guide_size=1
        let g:indent_guides_enable_on_vim_startup=1
    endif

    if exists('g:multi_cursor_insert_maps')
        echom "Configuring Indent Guides..."
        " Default highlighting (see help :highlight and help :highlight-link)
        highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
        highlight link multiple_cursors_visual Visual
        function! Multiple_cursors_before()
            colorscheme base16-flat
            call PostThemeSettings()
            call WhoaColorColumn('black','DarkOliveGreen3')
            if exists('g:very_visual_mode_switching')
                let g:very_visual_mode_switching=0
            endif
        endfunction
        function! Multiple_cursors_after()
            colorscheme base16-railscasts
            call PostThemeSettings()
            call WhoaColorColumn('black','coral4')
            if exists('g:very_visual_mode_switching')
                let g:very_visual_mode_switching=1
            endif
        endfunction
    endif

    echom "Ready."
endfunction

if has('autocmd')
    augroup plugin_setup
        " Plugins are loaded *after* Vim has finished processing .vimrc,
        " so we test for their existence and do stuff on VimEnter.
        autocmd VimEnter * call SetPluginOptions()
    augroup END
endif

" Keep this last.
set secure
