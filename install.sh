#! /usr/bin/env bash

# set constant
repo_url="https://github.com/yaoandy107/.shconf"
repo_name=".shconf"
reqirements="git"

# check reqirements
for app in $reqirements; do
    if ! command -v $app > /dev/null; then
        echo Could not find '`'$app'`', installation stopped.
        exit 1
    fi
done

# remove if already exist
if [ -d ~/$repo_name ]; then
    rm -rf ~/$repo_name
fi

# clone into computer
git clone $repo_url ~/$repo_name
if [ $? != 0 ]; then
    echo Could not clone $repo_name.
    exit 2
fi

# setup vim
if command -v vim > /dev/null 2>&1; then
    if [ -f ~/.vimrc ]; then
        mv ~/.vimrc ~/.vimrc.bak
    fi
    echo "source ~/$repo_name/vim/.vimrc" >> ~/.vimrc
else
    echo Could not find '`'vim'`'.
fi

# setup tmux
if command -v tmux > /dev/null 2>&1; then
    if [ -f ~/.tmux.conf ]; then
        mv ~/.tmux.conf ~/.tmux.conf.bak
    fi
    echo "source ~/$repo_name/tmux/tmux.conf" >> ~/.tmux.conf
else
    echo Could not find '`'tmux'`'.
fi

# setup zsh
if command -v zsh > /dev/null 2>&1; then
    if [ -d ~/.oh-my-zsh ]; then
        if [ -f ~/.zshrc ]; then
            mv ~/.zshrc ~/.zshrc.bak
        fi
        echo "source ~/$repo_name/zsh/.zshrc" >> ~/.zshrc
        # install powerlevel9k theme
        if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}//themes/powerlevel9k ]; then
            git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel9k
        # install zsh-autosuggestions
        if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        fi
        # install zsh-syntax-highlighting
        if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        fi
    else
        echo Could not find '`'oh-my-zsh'`'.
    fi
else
    echo Could not find '`'zsh'`'.
fi

# finished
echo
echo Done! $repo_name was installed.
