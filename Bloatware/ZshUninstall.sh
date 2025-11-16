#!/bin/sh

# Uninstall Zsh + Oh My Zsh + Powerlevel10k theme (macOS & Linux)
# run: sh -c "$(curl -fsSL "$(echo "$(curl -s "https://api.github.com/gists/254e58bd87009963b3f58405d75cbe6c")" | grep -o '"raw_url": *"[^"]*"' | cut -d'"' -f4)")"

# Remove installations + configurations
rm -f ~/.p10k.zsh
rm -rf -- ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sh ~/.oh-my-zsh/tools/uninstall.sh -y
sudo chsh -s $(which bash)
if [ "$(uname -s)" = "Darwin" ]; then
  brew uninstall zsh
else
  sudo apt remove zsh -y
  sudo apt autoremove -y
fi
rm -Rf ~/.zsh*