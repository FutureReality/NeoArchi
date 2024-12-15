#!/bin/bash

xml_file="/etc/xml/rofi_app.xml"



programs=($(xmllint --xpath "//program/name/text()" "$xml_file"))
descriptions=($(xmllint --xpath "//program/description/text()" "$xml_file"))
commands=($(xmllint --xpath "//program/command/text()" "$xml_file"))



menu_items=()
for i in "${!programs[@]}"; do
    menu_items+=("${programs[i]} (${descriptions[i]})")
done



selected_program=$(printf "%s\n" "${menu_items[@]}" | rofi -dmenu -p "Selecciona un programa:")
selected_name=$(echo "$selected_program" | sed 's/ (\(.*\))//')



#for i in "${!programs[@]}"; do
#    if [[ "${programs[i]}" == "$selected_name" ]]; then
#        eval "kitty -T 'WithRofi' ${commands[i]}" &
#        break
#    fi
