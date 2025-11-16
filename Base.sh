#Script Created by Nicolas Peralta
#Date: 2021-09-15
#Last Update: 2025-11-09 - 18:38hs

#!/bin/bash

# Actualización del sistema y preparación del usuario
apt update && apt upgrade -y
apt-get install sudo && sudo usermod -aG sudo nicolas

# Basics Instalation (tu versión completa)
sudo apt install ufw clamav clamav-daemon git wget curl zsh htop preload nala fastfetch -y

# Permite acceso a OMV desde el explorador de archivos (Thunar)
sudo apt install gvfs-backends gvfs-fuse smbclient -y

# Deshabilitar Avahi
sudo systemctl disable --now avahi-daemon.service avahi-daemon.socket

# Firewall Setup básico con UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw limit 22/tcp comment 'SSH con limitación'
sudo ufw limit 3389/tcp comment 'RDP con limitación'

# Puertos específicos opcionales
# sudo ufw allow 3306   # Puerto MySQL
# sudo ufw allow 8006   # Puerto Proxmox
# sudo ufw allow 3389   # Puerto RDP

# Activación del firewall
sudo ufw enable
sudo ufw reload

# Anti Virus - ClamAV
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl start clamav-freshclam
sudo systemctl start clamav-daemon
