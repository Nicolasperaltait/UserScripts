
sudo apt install ufw && sudo ufw enable 

# Firewall setups

# Puertos Especificos
    sudo ufw limit 22/tcp  # Limita las coneccions por puerto 22 ssh
    sudo ufw allow 8006    # Permite el acceso al puerto 8006 usado por proxmox                                          
    sudo ufw allow 3306    # Permite el acceso al puerto 3306 usado por MySQL
    sudo ufw allow 3389    # Permite el acceso al puerto 3389 usado por RDP


sudo ufw status 