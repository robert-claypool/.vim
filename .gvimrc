if has("gui_running")
    " Font selection is based on the OS, from http://stackoverflow.com/a/3316521/23566
    if has("gui_gtk2")
        set guifont=Inconsolata\ 12
    elseif has("gui_macvim")
        set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
        set guifont=Consolas:h11:cANSI
    endif

    " Make the window larger than gVim's default
    set lines=45 columns=130

    set guioptions-=T   " no toolbar
    set guioptions-=r   " no right-side scrollbar
    set guioptions-=e   " no fancy tabs, make them like look like console tabs

    set nowrap
    set guioptions+=b   " horizontal scrolling with no wrapping

    " In NORMAL mode, have a single command to toggle wrapping
    " and show/hide the bottom horizontal scrollbar accordingly.
    nnoremap <expr> <localleader>wp ':set wrap! guioptions'.'-+'[&wrap]."=b\r"
endif
