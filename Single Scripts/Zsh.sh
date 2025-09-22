#!/bin/bash

cd /home/nicolas
su nicolas
sudo apt update && sudo apt install zsh curl git -y

export RUNZSH=no
yes |  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

