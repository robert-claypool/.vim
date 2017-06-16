# .vim
Plugins are extracted to a subdirectory under `~/.vim/bundle`, and [Pathogen](https://github.com/tpope/vim-pathogen) adds them to the `runtimepath`. To use this `.vim`, (1) clone the repo (2) clone the submodules and (3) setup symbolic links to `.vimrc`:

### On Linux
Run `./bootstrap.sh` or...

```Shell
git clone git@github.com:robert-claypool/.vim.git
ln -s /path/to/the/repo/.vimrc ~/.vimrc
ln -s /path/to/the/repo/.gvimrc ~/.gvimrc
ln -s /path/to/the/repo ~/.vim
cd .vim
git submodule init
git submodule update
```
### On Windows
* Both `~\.vimrc` and `~\_vimrc` work fine on my Windows machine, but using a `~\.vim` directory does not.
On Windows, the directory for user-specific scripts is `~\vimfiles` by default, not `~\.vim`.
* Also it's better to create the symbolic links with `cdm.exe` and `mklink` since the `ln` command
in Cygwin or msysgit will probably return a "Permission Denied" error.

The commands below account for these Windows specific issues:

```Shell
cd C:\path\to\the\repo
git clone git@github.com:robert-claypool/.vim.git
mklink %HOMEPATH%\_vimrc C:\path\to\the\repo\.vimrc
mklink %HOMEPATH%\_gvimrc C:\path\to\the\repo\.gvimrc
mklink /D %HOMEPATH%\vimfiles C:\path\to\the\repo
cd .vim
git submodule init
git submodule update
```

### External Program Dependencies
Prettier is awesome, install it with `npm install -g prettier`.

In Visual mode, `<localleader>=f` calls Prettier on the selected lines of
JavaScript, use `<localleader>=t` for TypeScript.

TypeScript support is provided by [Tsuquyomi](https://github.com/Quramy/tsuquyomi)
which depends on [vimproc](https://github.com/Shougo/vimproc.vim), Node, and
Node TypeScript. Follow the [Tsuquyomi README](https://github.com/Quramy/tsuquyomi)
to get it working.

JavaScript auto-completion is better with Tern.
To get it working, Tern must be npm installed into bundle/tern_for_vim and
Node must be globally available. See https://github.com/ternjs/tern_for_vim
