#!/bin/bash
sudo apt  update && sudo apt  upgrade -y && sudo apt  install sudo git -y 

mkdir -p github && cd github

git clone https://github.com/Nicolasperaltait/UserScripts.git

cd UserScripts 

chmod -R  775 *.sh 

./BaseScript.sh
