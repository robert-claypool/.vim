" Font selection based on the OS, from http://stackoverflow.com/a/3316521/23566
if has("gui_running")
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
endif
