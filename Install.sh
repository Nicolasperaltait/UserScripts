#!/bin/bash

# Actualización del sistema y preparación del usuario

apt update && apt-get install sudo && sudo usermod -aG sudo nicolas

apt install sudo git -y 

mkdir -p /home/nicolas/Github && cd Github 

git clone https://github.com/Nicolasperaltait/UserScripts.git

cd UserScripts 

chmod -R  775 *.sh 

echo "Scriptes descargados en /home/nicolas/Github/UserScripts" 

