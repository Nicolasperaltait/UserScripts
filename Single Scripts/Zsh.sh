#!/bin/bash
# ZSH + OhMyZsh

echo "y" | sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Run To make ZSH default shell

chsh -s $(which zsh) &&

# Plugins Zsh

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &&
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &&

# cd / && cd root && nano .zshrc


# Verifica si la línea plugins=(git está sola en el .zshrc de root y la reemplaza por la lista completa de plugins
ZSHRC_PATH="/root/.zshrc"
if grep -q '^plugins=(git)$' "$ZSHRC_PATH"; then
    # Reemplaza la línea por la lista completa de plugins
    sed -i 's/^plugins=(git)$/plugins=(git sudo zsh-syntax-highlighting zsh-autosuggestions)/' "$ZSHRC_PATH"
fi