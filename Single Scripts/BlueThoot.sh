#!/bin/bash

# TESTEAR


# Instalador automático Bluetooth Debian 13 XFCE
# Autor: Nicolás

echo "[INFO] Instalando soporte Bluetooth completo..."

sudo apt update
sudo apt install -y \
  bluetooth bluez bluez-obexd blueman rfkill \
  libbluetooth3 libldacbt-abr2 libldacbt-enc2 libspa-0.2-bluetooth

echo "[INFO] Habilitando servicio..."
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "[INFO] Cargando módulos del kernel..."
sudo modprobe btusb btrtl btintel btbcm btmtk bluetooth rfkill toshiba_bluetooth

echo "[INFO] Estado del adaptador:"
bluetoothctl list
bluetoothctl show

echo "[OK] Instalación Bluetooth completada."
