#!/bin/bash


apt update && sudo apt install sudo git -y 

mkdir -p github && cd github

git clone https://github.com/Nicolasperaltait/UserScripts.git

cd UserScripts 

chmod -R  775 *.sh 

bash base.sh
