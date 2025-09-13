
#!/bin/bash

# Ejecutar como Root

# Agregar el usuario 'nicolas' al grupo sudo
sudo usermod -aG sudo nicolas

# Agregar la línea al archivo sudoers si no existe
LINE="nicolas ALL=(ALL:ALL) ALL"
FILE="/etc/sudoers"

if ! sudo grep -Fxq "$LINE" "$FILE"; then
    echo "$LINE" | sudo EDITOR='tee -a' visudo
else
    echo "La línea ya existe en $FILE"
fi