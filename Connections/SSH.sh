#!/bin/bash


sudo apt update && sudo apt upgrade -y

sudo apt install openssh-server -y
sudo apt install openssh-client 

sudo service ssh start

sudo ufw allow ssh

sudo systemctl status ssh