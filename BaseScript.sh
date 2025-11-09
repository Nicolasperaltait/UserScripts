#Script Created by Nicolas Peralta
#Date: 2021-09-15
#Last Update: 2025-11-09 - 18:38hs

#!/bin/bash

sudo apt update && sudo apt upgrade -y
apt-get install sudo && sudo usermod -aG sudo

sudo apt update && sudo apt upgrade -y && sudo apt install ufw clamav clamav-daemon -y

# Permite acceso a OMV desde el explorador de archivos (Thunar).
sudo apt install gvfs-backends gvfs-fuse

# Deshabilitar Avahi (servicio de descubrimiento de red)- Usado por impresoras de red y otros dispositivos no necesarios. 
sudo systemctl disable --now avahi-daemon.service avahi-daemon.socket

#  Firewall Setup basico con UFW

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

