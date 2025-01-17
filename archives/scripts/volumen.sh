#!/bin/bash

# Creamos la función que nos permite agarrar el volumen;
# básicamente se muestra información del volumen "master" y se recorta la información hasta solo tener el int
function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

# Esta función verifica si el audio se encuentra muteado.
# Busca la palabra "off" en la salida de amixer.
function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

# Declaramos un par de variables, la primera manda el volumen actual mientras que la segunda
# manda la info necesarias para que dunst pueda hacer uso de su barra. Luego las variables
# son mandadas a dunst.
function send_notification {
    volume=`get_volume`
    bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
    dunstify -i audio-volume-muted-blocking -t 1000 -r 2593 -u normal "    $bar"
}

# Segun lo enviado se ejecuta uno de los tres casos:
case $1 in
    up)
	# Activamos el volumen si está muteado y lo incrementamos un 5%
	amixer -D pulse set Master on > /dev/null
	amixer -D pulse sset Master 5%+ > /dev/null
	send_notification
	;;
    down)
	# Activamos el volumen si está muteado y lo reducimos un 5%
	amixer -D pulse set Master on > /dev/null
	amixer -D pulse sset Master 5%- > /dev/null
	send_notification
	;;
    mute)
	# Alternamos entre mute y unmute;
	# si el estado es mute, se notifica con un mensaje "Mute",
	# caso contrario, se envía la barra de volumen.
	amixer -D pulse set Master 1+ toggle > /dev/null
	if is_mute ; then
	    dunstify -i audio-volume-muted -t 1000 -r 2593 -u normal "Mute"
	else
	    send_notification
	fi
	;;
esac
