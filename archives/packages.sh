#Paquetes relacionados con el entorno grafico
pacman -Syu qtile polybar lightdm lightdm-gtk-greeter lightdm-webkit2-greeter arandr

#Entorno grafico no-esencial
pacman -Syu kitty nitrogen dunst rofi picom

#Servicios necesarios y utilidades del sistema
pacman -Syu pulseaudio networkmanager cups alsa-utils usbutils net-tools util-linux build-essential

#paquetes basicos para archivos
pacman -Syu nano vim feh mpv unrar unzip p7zip gzip

#paquetes para analisis del sistema y de red
pacman -Syu neofetch bottom iftop tcpdump curl wget sysstat lm-sensor

#paquetes de seguridad
pacman -Syu ufw iptables pass fail2ban openssl logwatch

#Ofimatica y variado
pacman -Syu firefox virtualbox git

#Lenguajes
pacman -Syu python3 python-pip jdk-openjdk php mysql

#paquetes opcionales
pacman -Syu qutebrowser neovim libreoffice mpd ncmpcpp
