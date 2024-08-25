# Inicial Script For servers startup

#!/bin/bash

# privilege upgrade
su root && 
apt update && apt upgrade -y
apt-get install sudo &&
sudo usermod -a -G sudo nicolas

#Basics Instalation
apt install ufw clamav clamav-daemon git wget curl zsh htop preload -y &&

# Firewall setup

# Puertos Especificos
    sudo ufw limit 22/tcp                                                 # Limita las coneccions por puerto 22 ssh 

  # Reglas Generales
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

  #habilitacion
    sudo ufw enable                                                       # Habilitar UFW para gestionar el firewall

# AV setup

    sudo systemctl stop clamav-freshclam                                   # Detener el servicio de actualización de ClamAV
    sudo freshclam                                                         # Actualizar la base de datos de firmas de virus de ClamAV
    sudo systemctl start clamav-freshclam                                  # Iniciar de nuevo el servicio de actualización de ClamAV
    sudo systemctl start clamav-daemon                                     # Iniciar de nuevo el daemon de actualización de ClamAV

# ZSH + OhMyZsh

bash

echo "y" | sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

