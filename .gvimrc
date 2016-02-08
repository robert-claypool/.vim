if has("gui_running")
    " Font selection is based on the OS, from http://stackoverflow.com/a/3316521/23566
    if has("gui_gtk2")
        set guifont=Inconsolata\ 12
    elseif has("gui_macvim")
        set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
        set guifont=Consolas:h12:cANSI
    endif

    if has('autocmd')
        augroup start_maximized
            " From http://superuser.com/a/140604/13481
            autocmd GUIEnter * simalt ~x
        augroup END
    else
        set lines=45 columns=130
    endif

    set guioptions-=T   " no toolbar
    set guioptions-=e   " no fancy tabs, make them like look like console tabs

    set nowrap
    set guioptions+=b   " horizontal scrolling with no wrapping

    " In NORMAL mode, have a single command to toggle wrapping
    " and show/hide the bottom horizontal scrollbar accordingly.
    nnoremap <expr> <localleader>wp ':set wrap! guioptions'.'-+'[&wrap]."=b\r"
endif
