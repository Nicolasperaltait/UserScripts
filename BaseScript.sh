#Script Created by Nicolas Peralta
#Date: 2021-09-15
#Last Update: 2025-01-25 - 18:38hs

#!/bin/bash
# Inicial Script For servers startup // need to ve root and bash  
sudo apt update && sudo apt upgrade -y
apt-get install sudo && sudo usermod -aG sudo

#Basics Instalation
apt install ufw clamav clamav-daemon git wget curl zsh htop preload nala fastfetch -y

# Firewall setups

# Puertos Especificos
    sudo ufw allow 8006    # Permite el acceso al puerto 8006 usado por proxmox                                          
    sudo ufw allow 3306    # Permite el acceso al puerto 3306 usado por MySQL
    sudo ufw allow 3389    # Permite el acceso al puerto 3389 usado por RDP
    sudo ufw limit 22/tcp  # Limita las coneccions por puerto 22 ssh
  # Reglas Generales
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

  #habilitacion
    sudo ufw enable                                                  # Habilitar UFW para gestionar el firewall

# AV setup

    sudo systemctl stop clamav-freshclam                                # Detener el servicio de actualización de ClamAV
    sudo freshclam                                                      # Actualizar la base de datos de firmas de virus de ClamAV
    sudo systemctl start clamav-freshclam                               # Iniciar de nuevo el servicio de actualización de ClamAV
    sudo systemctl start clamav-daemon                                  # Iniciar de nuevo el daemon de actualización de ClamAV
