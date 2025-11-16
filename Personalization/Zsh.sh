#!/bin/bash

cd /home/nicolas
sudo apt update && sudo apt install zsh curl git -y

export RUNZSH=no
yes |  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sudo chsh -s $(which zsh) &&

yes | wget -O ~/.oh-my-zsh/themes/kali-like.zsh-theme https://raw.githubusercontent.com/clamy54/kali-like-zsh-theme/master/kali-like.zsh-theme

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

cat << 'EOF' >> ~/.zshrc

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="kali-like"
plugins=(git
sudo
zsh-syntax-highlighting
zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

EOF

zsh