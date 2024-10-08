#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install zsh curl -y

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

