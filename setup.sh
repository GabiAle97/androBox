#!/bin/bash

echo -e "\nInstalling required dependencies"

termux-change-repo
pkg upgrade -y
pkg install x11-repo tur-repo -y
pkg install pulseaudio git virglrenderer-android mesa wget fontconfig freetype libpng termux-x11-nightly cabextract zenity openbox file xorg-xrandr xterm iconv termux-exec -y 

if [ ! -d ~/storage ]
then
     echo -e "\nGranting internal storage permissions"
     termux-setup-storage
     sleep 25
fi

[[ ! -f /sdcard/glibc_prefix.tar.xz ]] && wget https://github.com/Pipetto-crypto/androBox/releases/download/glibc_prefix/glibc_prefix.tar.xz -P /sdcard
tar -xvf /sdcard/glibc_prefix.tar.xz -C $PREFIX

echo -e "
1.Wine 8.0 Stable(Adreno 7xx users recommended)
2.Wine 8.14 Devel
3.Wine 8.22 GE
"
read -p "Select a wine version to install:" installchoice

case $installchoice in
1) 
    [[ ! -f /sdcard/wine-8.0-amd64.tar.xz ]] && wget https://github.com/Pipetto-crypto/androBox/releases/download/wine-8.0/wine-8.0-amd64.tar.xz -P /sdcard
    tar -xvf /sdcard/wine-8.0-amd64.tar.xz -C $PREFIX/glibc/opt
    ;;
2)
    [[ ! -f /sdcard/wine-8.14-amd64.tar.xz ]] && wget https://github.com/Pipetto-crypto/androBox/releases/download/wine/wine-8.14-amd64.tar.xz -P /sdcard
    tar -xvf /sdcard/wine-8.14-amd64.tar.xz -C $PREFIX/glibc/opt
    ;;
3)
    [[ ! -f /sdcard/wine-GE-8.22-amd64.tar.xz ]] && wget https://github.com/GabiAle97/androBox/releases/download/wine-GE/wine-GE-8.22-amd64.tar.xz -P /sdcard
    tar -xvf /sdcard/wine-GE-8.22-amd64.tar.xz -C $PREFIX/glibc/opt
    ;;
esac

mv $PREFIX/glibc/opt/wine-*-amd64 $PREFIX/glibc/opt/wine

git clone https://github.com/Pipetto-crypto/androBox.git -b androBoxNew

for item in $HOME/androBox/scripts/*
do
   [[ ! -d $item ]] && chmod +x $item && mv $item $PREFIX/bin
done

mkdir -p /sdcard/androBox
mv $HOME/androBox/configs/* /sdcard/androBox

echo "check_certificate = off" > $HOME/.wgetrc

rm -rf $HOME/androBox && rm -rf $HOME/.wine
wine wineboot
update-scripts
pfxupdate

cat > $HOME/.androBox <<- EOM
#androBox configuration file

checkres=enabled
services=enabled
EOM
 
