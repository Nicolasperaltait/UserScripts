#Script Created by Nicolas Peralta
#Date: 2021-09-15
#Last Update: 2025-01-25 - 18:38hs



#!/bin/bash
echo "you need to be root"

# Inicial Script For servers startup // need to ve root and bash 
 
apt update && apt upgrade -y
apt-get install sudo &&
#sudo usermod -a -G sudo nicolas

#Basics Instalation
apt install ufw clamav clamav-daemon git wget curl zsh htop preload nala neofetch font-manager -y &&

# Firewall setups

# Puertos Especificos
    sudo ufw limit 22/tcp  # Limita las coneccions por puerto 22 ssh
    sudo ufw allow 8006    # Permite el acceso al puerto 8006 usado por proxmox                                          
    sudo ufw allow 3306    # Permite el acceso al puerto 3306 usado por MySQL
    sudo ufw allow 3389    # Permite el acceso al puerto 3389 usado por RDP
    
  # Reglas Generales
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

  #habilitacion
    sudo ufw enable -y                                                  # Habilitar UFW para gestionar el firewall

# AV setup

    sudo systemctl stop clamav-freshclam                                # Detener el servicio de actualización de ClamAV
    sudo freshclam                                                      # Actualizar la base de datos de firmas de virus de ClamAV
    sudo systemctl start clamav-freshclam                               # Iniciar de nuevo el servicio de actualización de ClamAV
    sudo systemctl start clamav-daemon                                  # Iniciar de nuevo el daemon de actualización de ClamAV

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