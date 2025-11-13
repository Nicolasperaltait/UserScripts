#!/bin/bash
sudo apt update && sudo apt upgrade -y && sudo apt install ufw clamav clamav-daemon -y

sudo systemctl disable --now avahi-daemon.service avahi-daemon.socket

#  Firewall Setup

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw limit 22/tcp comment 'SSH con limitación'
sudo ufw limit 3389/tcp comment 'RDP con limitación'

  # Puertos Especificos
    #sudo ufw allow 3306                                                                      # Puerto MySQL                    
    #sudo ufw allow 8006                                                                      # Puerto Proxmox
    #sudo ufw allow 3389                                                                      # Puerto RDP

  #habilitacion
    sudo ufw enable                                                                             # Habilitar UFW para gestionar el firewall
    sudo ufw reload


# Anti Virus
    sudo systemctl stop clamav-freshclam                                                       # Detener el servicio de actualización de ClamAV
    sudo freshclam                                                                             # Actualizar la base de datos de firmas de virus de ClamAV
    sudo systemctl start clamav-freshclam                                                      # Iniciar de nuevo el servicio de actualización de ClamAV
    sudo systemctl start clamav-daemon                                                         # Habilitar y iniciar el servicio de ClamAV


#TEST