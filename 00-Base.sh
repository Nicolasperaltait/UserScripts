#!/bin/bash
echo "you need to be root"

# Inicial Script For servers startup // need to ve root and bash 
 
apt update && apt upgrade -y
apt-get install sudo &&
sudo usermod -a -G sudo nicolas

#Basics Instalation
apt install ufw clamav clamav-daemon git wget curl zsh htop preload -y &&

# Firewall setup

# Puertos Especificos
    sudo ufw limit 22/tcp                                               # Limita las coneccions por puerto 22 ssh 

  # Reglas Generales
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

  #habilitacion
    sudo ufw enable                                                     # Habilitar UFW para gestionar el firewall

# AV setup

    sudo systemctl stop clamav-freshclam                                # Detener el servicio de actualización de ClamAV
    sudo freshclam                                                      # Actualizar la base de datos de firmas de virus de ClamAV
    sudo systemctl start clamav-freshclam                               # Iniciar de nuevo el servicio de actualización de ClamAV
    sudo systemctl start clamav-daemon                                  # Iniciar de nuevo el daemon de actualización de ClamAV

# ZSH + OhMyZsh

echo "y" | sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# Plugins Zsh

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

cd / && cd root && nano .zshrc


#add to the .zhhrc in plugins part whitout #

#   plugins=(git
#   sudo
#   zsh-syntax-highlighting
#   zsh-autosuggestions)

#funciona correctamente 27-10-24