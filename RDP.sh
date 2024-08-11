#!/bin/bash

#=======================================================================================#

# automatizacion de protocolo RDP. 

#=======================================================================================#

# Si esto se ejecuta sin el script start se debe instalar el entorno xfce sino no tendra efecto, descomentar el comando de abajo en ese caso. 


 sudo apt update && sudo apt upgrade -y && sudo apt install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils -y &&

#=======================================================================================#

# Es necesario un Reboot. 


# Instalacion y configuracion del protocolo RDP. 

sudo apt install xrdp -y &&                                                             # instalacion del protocolo. 

cd / && cd home/nicolas/Debian12/Dotfiles && chmod 755 startwm.sh &&                    # Nos aseguramos que estemos en el path correcto. 

sudo cp -a -f startwm.sh /etc/xrdp &&                                                   # -a Copia archivo permisos y metadata // -f = Forza la copia, no se puede copiar si no existe el archivo. 

sudo systemctl restart xrdp &&                                                          # Reiniciamos el servicio xrdp para que se apliquen los cambios. 

# sudo ufw allow from 192.168.1.0/24 to any port 3389                                   # Permitimos el acceso al puerto 3389 desde la red local.

sudo ufw allow 3389 &&                                                                  # Permitimos el acceso al puerto 3389 desde cualquier lugar. // NO SEGURO!!!!  

sudo systemctl status xrdp &&                                                           # Verificamos el estado del servicio xrdp                                                                     # Permitimos el acceso al puerto 3389 desde cualquier lugar. // NO SEGURO!!!!  

#=======================================================================================#        
        
                
 echo "Reinicie el sistema para que los cambios tengan efecto."
 