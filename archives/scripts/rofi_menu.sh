#!/bin/bash

# Ruta al archivo XML que contiene la información de los programas.
xml_file="/etc/xml/rofi_app.xml"

# Extrae los nombres, descripciones y comandos de los programas desde el archivo XML.
programs=($(xmllint --xpath "//program/name/text()" "$xml_file"))
descriptions=($(xmllint --xpath "//program/description/text()" "$xml_file"))
commands=($(xmllint --xpath "//program/command/text()" "$xml_file"))

# Construye una lista de elementos para el menú, combinando el nombre y la descripción.
menu_items=()
for i in "${!programs[@]}"; do
    menu_items+=("${programs[i]} (${descriptions[i]})")
done

# Muestra el menú con Rofi y permite al usuario seleccionar un programa.
selected_program=$(printf "%s\n" "${menu_items[@]}" | rofi -dmenu -p "Selecciona un programa:")

# Extrae únicamente el nombre del programa seleccionado, eliminando la descripción.
selected_name=$(echo "$selected_program" | sed 's/ (\(.*\))//')

# Cambiamos el nombre de la aplicacion en caso de que tuvieramos que identificarlo por el modo en le cual la iniciamos.
for i in "${!programs[@]}"; do
    if [[ "${programs[i]}" == "$selected_name" ]]; then
        eval "kitty -T 'WithRofi' ${commands[i]}" &
        break
    fi
