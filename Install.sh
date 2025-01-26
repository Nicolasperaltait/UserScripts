#!/bin/bash
apt update && apt upgrade -y && apt install sudo git -y 

mkdir -p github && cd github

git clone https://github.com/Nicolasperaltait/UserScripts.git

cd UserScripts && chmod 775 *.sh 

install.sh
