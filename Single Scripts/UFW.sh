#!/bin/bash

# --------------------------------------
# Configuración de Firewall (UFW) para Proxmox/OMV
# --------------------------------------

# Detener UFW para evitar conflictos
sudo ufw --force disable

# Resetear todas las reglas (¡cuidado!)
sudo ufw --force reset

# Políticas por defecto
sudo ufw default deny incoming
sudo ufw default allow outgoing

# ----------------------------
# Reglas Esenciales
# ----------------------------

# SSH (con rate limiting para evitar fuerza bruta)
sudo ufw limit 22/tcp comment "SSH con protección contra fuerza bruta"

# Interfaz Web de Proxmox
sudo ufw allow 8006/tcp comment "GUI de Proxmox (HTTPS)"

# SMB/CIFS para compartir archivos (solo red local)
sudo ufw allow from 192.168.1.0/24 to any port 445/tcp comment "SMB para red local"

# ----------------------------
# Reglas Adicionales (Personalizar)
# ----------------------------

# RDP para Windows (solo red local)
sudo ufw allow from 192.168.1.0/24 to any port 3389/tcp comment "Acceso RDP a VM Windows"

# MySQL (opcional, descomentar si es necesario)
# sudo ufw allow from 192.168.1.0/24 to any port 3306/tcp comment "MySQL"

# ----------------------------
# Eliminar Reglas Inseguras
# ----------------------------
sudo ufw delete allow 9090/tcp      # Cockpit
sudo ufw delete allow 137:139/tcp   # NetBIOS
sudo ufw delete allow 137:139/udp
sudo ufw delete allow 2049/tcp      # NFS
sudo ufw delete allow 111/tcp       # Portmapper
sudo ufw delete allow 111/udp
sudo ufw delete allow 3670          # Servicio desconocido

# ----------------------------
# Aplicar Configuración
# ----------------------------
sudo ufw --force enable
sudo ufw reload

# Mostrar estado final
echo -e "\n\033[1;36mEstado final del firewall:\033[0m"
sudo ufw status verbose

# --------------------------------------
# Instrucciones Post-Ejecución
# --------------------------------------
echo -e "\n\033[1;32mConfiguración completada. Verifica:\033[0m"
echo "1. Reemplaza '192.168.1.0/24' con tu red real"
echo "2. Si usas IPv6, añade reglas equivalentes"
echo "3. Para acceso externo, usa VPN (Recomendado)"