# set constant
repo='.shconf'

# check reqirements
for app in git; do
    if ! command -v $app > /dev/null; then
        echo 'Could not find `'$app'`, installation stopped.'
        exit 1
    fi
done

# clone into computer
if [ -d ~/$repo ]; then
    rm -rf ~/$repo
fi
git clone https://github.com/yaoandy107/$repo ~/$repo
if [ $? != 0 ]; then
    echo Could not clone $repo.
    exit 2
fi

# setup vim
if command -v vim > /dev/null; then
    mv ~/.vimrc ~/.vimrc.bak
    echo "source ~/$repo/vim/.vimrc" >> ~/.vimrc
else
    echo Could not find `vim`.
fi

# setup tmux
if command -v tmux > /dev/null; then
    mv ~/.tmux.conf ~/.tmux.conf.bak
    echo "source ~/$repo/tmux/tmux.conf" >> ~/.tmux.conf
else
    echo Could not find `tmux`.
fi

# setup zsh
if command -v zsh > /dev/null; then
    if [ -d ~/.oh-my-zsh ]; then
        mv ~/.zshrc ~/.zshrc.bak
        echo "source ~/$repo/zsh/.zshrc" >> ~/.zshrc
        # install zsh-autosuggestions
        if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        fi
        # install zsh-syntax-highlighting
        if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        fi
    else
        echo Could not find `oh-my-zsh`.
    fi
else
    echo Could not find `zsh`.
fi

