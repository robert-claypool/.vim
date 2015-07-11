# .vim
Plugins are extracted to a subdirectory under `~/.vim/bundle`, and [Pathogen](https://github.com/tpope/vim-pathogen) adds them to the `runtimepath`. To use this `.vim`, (1) clone the repo (2) clone the submodules and (3) setup a symbolic links to `.vimrc`:

### On Linux
```Shell
git clone git@github.com:robert-claypool/.vim.git ~/.vim
ln -s /path/to/the/repo/.vim/.vimrc ~/.vimrc
ln -s /path/to/the/repo/.gvimrc ~/.gvimrc
ln -s /path/to/the/repo/.vim ~/.vim
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
git clone git@github.com:robert-claypool/.vim.git ~/.vim
mklink %HOMEPATH%\_vimrc c:\path\to\the\repo\.vim\.vimrc
mklink %HOMEPATH%\_gvimrc c:\path\to\the\repo\.vim\.gvimrc
mklink /D %HOMEPATH%\vimfiles c:\path\to\the\repo\.vim
cd .vim
git submodule init
git submodule update
```
