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

# Pedir el nombre de usuario para la instalación
read -p "Ingrese el nombre de usuario en el cual desea instalar Oh My Zsh: " TARGET_USER

# Verificar que el usuario existe
if ! id "$TARGET_USER" &>/dev/null; then
    echo "El usuario '$TARGET_USER' no existe. Abortando."
    exit 1
fi

# No permitir instalar en root
if [ "$TARGET_USER" = "root" ]; then
    echo "No se recomienda instalar Oh My Zsh en root. Por favor, elija un usuario normal."
    exit 1
fi

TARGET_HOME=$(eval echo "~$TARGET_USER")

# Instalar Oh My Zsh para el usuario especificado
sudo -u "$TARGET_USER" sh -c "echo 'y' | sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""

# Cambiar la shell por defecto a zsh para el usuario especificado
sudo chsh -s "$(which zsh)" "$TARGET_USER"

# Instalar plugins para el usuario especificado
sudo -u "$TARGET_USER" git clone https://github.com/zsh-users/zsh-autosuggestions "${TARGET_HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
sudo -u "$TARGET_USER" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${TARGET_HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

# Abrir el .zshrc del usuario para editar
sudo -u "$TARGET_USER" nano "${TARGET_HOME}/.zshrc"
