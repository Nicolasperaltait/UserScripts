#!/bin/bash
 sudo apt update && sudo apt upgrade -y && 
 sudo apt install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils -y
# Instalacion y configuracion del protocolo RDP. 

sudo apt install xrdp -y                                                                # instalacion del protocolo. 

sudo systemctl restart xrdp &&                                                          # Reiniciamos el servicio xrdp para que se apliquen los cambios. 

sudo ufw allow 3389 &&                                                                  # Permitimos el acceso al puerto 3389 desde cualquier lugar. // NO SEGURO!!!!  

sudo systemctl status xrdp                                                            # Verificamos el estado del servicio xrdp                                                                     # Permitimos el acceso al puerto 3389 desde cualquier lugar. // NO SEGURO!!!!
 