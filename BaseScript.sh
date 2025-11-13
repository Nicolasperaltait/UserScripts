#Script Created by Nicolas Peralta
#Date: 2021-09-15
#Last Update: 2025-11-09 - 18:38hs

#!/bin/bash
<<<<<<< HEAD
# Inicial Script For servers startup // need to ve root and bash  
=======

>>>>>>> 317fb18cc4ff49f2c03b119c4293a1c93b38d783
sudo apt update && sudo apt upgrade -y
apt-get install sudo && sudo usermod -aG sudo nicolas

<<<<<<< HEAD
#Basics Instalation
sudo apt install ufw clamav clamav-daemon git wget curl zsh htop preload nala fastfetch -y
=======
sudo apt update && sudo apt upgrade -y && sudo apt install ufw clamav clamav-daemon -y
>>>>>>> 317fb18cc4ff49f2c03b119c4293a1c93b38d783

# Permite acceso a OMV desde el explorador de archivos (Thunar).
sudo apt install gvfs-backends gvfs-fuse

# Deshabilitar Avahi (servicio de descubrimiento de red)- Usado por impresoras de red y otros dispositivos no necesarios. 
sudo systemctl disable --now avahi-daemon.service avahi-daemon.socket

#  Firewall Setup basico con UFW

<<<<<<< HEAD
# Puertos Especificos
    #sudo ufw allow 8006    # Permite el acceso al puerto 8006 usado por proxmox                                          
    #sudo ufw allow 3306    # Permite el acceso al puerto 3306 usado por MySQL
    #sudo ufw allow 3389    # Permite el acceso al puerto 3389 usado por RDP
    sudo ufw limit 22/tcp  # Limita las coneccions por puerto 22 ssh
  # Reglas Generales
=======
>>>>>>> 317fb18cc4ff49f2c03b119c4293a1c93b38d783
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw limit 22/tcp comment 'SSH con limitación'
    sudo ufw limit 3389/tcp comment 'RDP con limitación'

# Puertos Especificos
    #sudo ufw allow 3306                                                                      # Puerto MySQL                    
    #sudo ufw allow 8006                                                                      # Puerto Proxmox
    #sudo ufw allow 3389                                                                      # Puerto RDP

# Habilitacion
    sudo ufw enable                                                                             # Habilitar UFW para gestionar el firewall
    sudo ufw reload

# Anti Virus
    sudo systemctl stop clamav-freshclam                                                       # Detener el servicio de actualización de ClamAV
    sudo freshclam                                                                             # Actualizar la base de datos de firmas de virus de ClamAV
    sudo systemctl start clamav-freshclam                                                      # Iniciar de nuevo el servicio de actualización de ClamAV
    sudo systemctl start clamav-daemon                                                         # Habilitar UFW para gestionar el firewall

