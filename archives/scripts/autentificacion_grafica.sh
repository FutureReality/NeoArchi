#!/bin/bash

# Ruta del archivo de bloqueo
LOCK_FILE="/tmp/restart_with_password.lock"

# Comprobar si el archivo de bloqueo existe
if [ -e "$LOCK_FILE" ]; then
    # Si el archivo de bloqueo existe, mostrar un mensaje y salir
    zenity --error --text="El reinicio ya está en proceso. Por favor espera."
    exit 1
else
    # Crear el archivo de bloqueo
    touch "$LOCK_FILE"

    # Mostrar el cuadro de diálogo para pedir la contraseña
    PASSWORD=$(zenity --password --title="Autentificacion requerida")
   
    # Verificar si se introdujo la contraseña
    if [ $? -eq 0 ]; then
        echo "$PASSWORD" | sudo -S reboot
    else
        zenity --error --text="Autenticacion cancelada."
    fi

    # Eliminar el archivo de bloqueo después de ejecutar el comando
    rm -f "$LOCK_FILE"
fi
