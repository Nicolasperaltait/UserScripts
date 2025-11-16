#!/bin/bash

while true; do
    # Ejecuta el ping y guarda la salida en una variable
    latency=$(ping -c 1 8.8.8.8 | awk -F'=' '/time=/ { printf("%.2f", $4) }')

    # Formato de salida para i3blocks
    echo "Latencia: ${latency} ms"
    #echo "#FF0000"  # Color opcional, aquí en rojo

    # Espera antes de volver a ejecutar el ping
    sleep 10
done
