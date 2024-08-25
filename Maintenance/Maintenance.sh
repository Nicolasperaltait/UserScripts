#!/bin/bash
# Paquetes necesarios: apt, clamav, clamav-daemon 
sudo apt update && sudo apt upgrade -y && sudo apt install ufw clamav clamav-daemon -y 

echo " --------------- LIMPIEZA --------------- "

sudo apt clean                                                   # Elimina los paquetes ya no necesarios en el sistema.
sudo apt autoremove -y                                           # Elimina paquetes instalados automáticamente y que ya no son necesarios.
sudo apt autopurge -y                                            # Elimina también los archivos de configuración residuales.


echo " --------------- AV scan --------------- "

    sudo systemctl stop clamav-freshclam                          # Detener el servicio de actualización de ClamAV
    sudo freshclam                                                # Actualizar la base de datos de firmas de virus de ClamAV
    sudo systemctl start clamav-freshclam                         # Iniciar de nuevo el servicio de actualización de ClamAV
    sudo systemctl start clamav-daemon                            # Habilitar y iniciar el servicio de ClamAV


#--------------------------------#

#!/bin/bash

# script de escaneo, te pide confirmacion. 

    read -p "¿Está seguro que desea ejecutar 'clamscan' en el directorio /home? (y/n): " confirm
    if [[ $confirm == "y" ]]; then                               # Verifica la respuesta del usuario
      sudo clamscan -r /home                                     # Ejecuta el comando si el usuario confirma
    else
      echo "Operación cancelada."                                # Mensaje en caso de cancelación
    fi

#echo " --------------- BKP Configs - Esto puede tardar un tiempo --------------- "

#  sudo cp .config -p -f -r /media/nicolas/Almacen/01-Cloud/06-DebianDotFiles

echo "--------------- Ya podes cerrar la terminal --------------- "