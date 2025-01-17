#!/bin/bash

# Hacemos una comprobacino de si el archivo se esta ejecutando con sudo
if [[ $EUID -ne 0 ]]; then
   echo "Ejecutar con sudo !!" 
   exit 1
fi

# Instalamos fig y cow para la "interfaz" de la instalacion, no pedimos confirmacion
echo "Interfaz de instalacion: Instalando figlet & cowsay"
pacman -S --noconfirm figlet cowsay

# Vamos creando las secciones, la de instalacion y las secciones de paquetes; La seccion de instalacion va con dos
#variables, asi vamos iterando sobre paquetes y secciones.
install_section() {
    section_name="$1"
    packages="$2"
    
    clear
    figlet "$section_name"
    cowsay -f dragon "$packages"

#Preguntamos si el usuario quiere instalar ese apartado.
    read -p "¿Deseas instalar estos paquetes? (s/n): " response
    if [[ "$response" =~ ^[Ss]$ ]]; then
        echo "Instalando paquetes..."
        pacman -Syu --noconfirm $packages
    else
        echo "Saltando instalación de paquetes..."
    fi
}

# Paquetes relacionados con el entorno gráfico
graphic_packages="qtile polybar lightdm lightdm-gtk-greeter lightdm-webkit2-greeter arandr"
install_section "Entorno Gráfico" "$graphic_packages"

# Entorno gráfico no-esencial
non_essential_graphic_packages="kitty nitrogen dunst rofi picom"
install_section "Entorno Gráfico No-Esencial" "$non_essential_graphic_packages"

# Servicios necesarios y utilidades del sistema
system_utilities="pulseaudio networkmanager cups cups-pdf alsa-utils usbutils net-tools util-linux base-devel"
install_section "Servicios y Utilidades del Sistema" "$system_utilities"

# Paquetes básicos para archivos
basic_file_tools="nano vim feh mpv unrar unzip p7zip gzip"
install_section "Paquetes Básicos para Archivos" "$basic_file_tools"

# Paquetes para análisis del sistema y de red
network_analysis="neofetch bottom iftop tcpdump curl wget sysstat"
install_section "Análisis del Sistema y Red" "$network_analysis"

# Paquetes de seguridad
security_packages="ufw iptables pass fail2ban openssl logwatch"
install_section "Paquetes de Seguridad" "$security_packages"

# Ofimática y variado
office_varied_packages="firefox virtualbox git"
install_section "Ofimática y Variado" "$office_varied_packages"

# Lenguajes
languages="python3 python-pip jdk-openjdk php mysql"
install_section "Lenguajes de Programación" "$languages"

# Paquetes opcionales
optional_packages="qutebrowser neovim libreoffice mpd ncmpcpp"
install_section "Paquetes Opcionales" "$optional_packages"

# Finalización
clear
cd theme/
sudo -u "$SUDO_USER" makepkg -sri

clear
figlet "Instalación Completa"
cowsay -f dragon "Paquetes seleccionados instalados! Deberias reiniciar"
