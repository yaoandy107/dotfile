#! /usr/bin/env bash

NAME=".shconf"
URL="https://github.com/yaoandy107/$NAME"

# Install application
function makeInstall {
    # Check argc
    if [ $# -ge 1 ]; then
        # macOS
        if [ "$(uname)" == "Darwin" ]; then
            # Ask for install brew
            if askQuestion "You must install brew, but do you want to install brew?" "Yn"; then
                /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
                result=$?; if [ $result -ne 0 ]; then return $result; fi
            brew install $1
            return $?
        fi

        # Debian / Ubuntu
        elif command -v apt > /dev/null 2>&1; then
            sudo apt install $1 -y
            return $?

        elif command -v apt-get > /dev/null 2>&1; then
            sudo apt-get install $1 -y
            return $?

        # Fedora / CentOS
        elif command -v dnf > /dev/null 2>&1; then
            sudo dnf -y install $1
            return $?

        elif command -v yum > /dev/null 2>&1; then
            sudo yum -y install $1
            return $?

        # Embedded
        elif command -v ipkg > /dev/null 2>&1; then
            sudo ipkg install $1
            return $?

        elif command -v opkg > /dev/null 2>&1; then
            sudo opkg install $1
            return $?

        # None
        else
            return 'QwQ'

        fi
    else
        return -1
    fi
}

# Ask for question
function askQuestion {
    # Check argc
    if [ $# -ge 2 ]; then
        # default yes
        if [ "$2" == "Yn" ]; then
            # Display question
            echo -n "$1 [Y/n] "
            # Input answer
            read ans
            for no in 'n' 'N' 'no' 'No' 'NO' 'nO'; do
                if [ "$ans" == "$no" ]; then ans="n"; break; fi
            done
        fi
        if [ "$ans" != "n" ]; then ans="y"; fi
        # default no
        if [ "$2" == "yN" ]; then
            # Display question
            echo -n "$1 [y/N] "
            # Input answer
            read ans
            for yes in 'y' 'Y' 'ye' 'Ye' 'yE' 'YE' 'yes' 'Yes' 'yEs' 'yeS' 'YEs' 'yES' 'YeS' 'YES'; do
                if [ "$ans" == "$yes" ]; then ans="y"; break; fi
            done
        fi
        if [ "$ans" != "y" ]; then ans="n"; fi
        # result
        [ "$ans" == "y" ]
        return $?
    else
        return -1
    fi
}

function main {
    # Require git
    if ! command -v git > /dev/null 2>&1; then
        # Ask for install git
        if askQuestion "You must install git, but do you want to install git?" "Yn"; then
            makeInstall git
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        else
            return 0
        fi
    fi

    # Remove local repo if exist
    if [ -d ~/$NAME ]; then
        rm -rf ~/$NAME
    fi

    # Clone repo
    git clone $URL ~/$NAME
    if [ $? != 0 ]; then
        echo "Could not clone $NAME."
        return 1
    fi

    # Require zsh
    if ! command -v zsh > /dev/null 2>&1; then
        # Ask for install zsh
        if askQuestion "You must install zsh, but do you want to install zsh?" "Yn"; then
            makeInstall zsh
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        else
            return 0
        fi
    fi
    # Config zsh
    if command -v zsh > /dev/null 2>&1; then
        # Require oh-my-zsh
        if ! [ -d ~/.oh-my-zsh ]; then
            sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's/env zsh//g')" || \
            sh -c "$(wget -qO- https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's/env zsh//g')"
        fi
        # Install zsh-autosuggestions
        if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        fi
        # Install zsh-syntax-highlighting
        if ! [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        fi
        if [ -f ~/.zshrc ]; then
            mv ~/.zshrc ~/.zshrc.bak
        fi
        echo "source ~/$NAME/config/zsh/sample.zshrc" >> ~/.zshrc
    fi

    # Check vim
    if ! command -v vim > /dev/null 2>&1; then
        # Ask for install vim
        if askQuestion "Do you want to install vim?" "yN"; then
            makeInstall vim
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        fi
    fi
    # Config vim
    if command -v vim > /dev/null 2>&1; then
        if [ -f ~/.vimrc ]; then
            mv ~/.vimrc ~/.vimrc.bak
        fi
        echo "source ~/$NAME/config/vim/sample.vimrc" >> ~/.vimrc
    fi

    # Check tmux
    if ! command -v tmux > /dev/null 2>&1; then
        # Ask for install tmux
        if askQuestion "Do you want to install tmux?" "yN"; then
            makeInstall tmux
            result=$?; if [ $result -ne 0 ]; then return $result; fi
        fi
    fi
    # Config tmux
    if command -v tmux > /dev/null 2>&1; then
        if [ -f ~/.tmux.conf ]; then
            mv ~/.tmux.conf ~/.tmux.conf.bak
        fi
        echo "source ~/$NAME/config/tmux/sample.tmux.conf" >> ~/.tmux.conf
    fi

    # Finished
    echo
    echo Done! $NAME was installed.
}

main