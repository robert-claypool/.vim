read -p "This script assumes your repo is at ~/git/.vim ... Continue? [y,n] " answer
case $answer in
    y|Y) ;;
    *)   echo "Cancelled." & exit 0 ;;
esac

ln -s ~/git/.vim/.vimrc ~/.vimrc
ln -s ~/git/.vim/.gvimrc ~/.gvimrc
ln -s ~/git/.vim ~/.vim

echo "Done."
echo "To setup plugins, run 'git submodule init' and 'git submodule update'."
