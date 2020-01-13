#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'

PKGS1="git feh xorg lightdm python3-pip fonts-hack-ttf i3 virtualbox"
PKGS2="i3lock rar unrar compton zsh chromium-browser rofi neofetch scrot arandr"
PKGS3="imagemagick rxvt-unicode libev-dev libxcb-composite0 libxcb-composite0-dev"
PKGS4="libxcb-xinerama0 libxcb-randr0 libxcb-xinerama0-dev zip unzip libxcb-xkb-dev"
PKGS5="libxcb-image0-dev libxcb-util-dev libxkbcommon-x11-dev lightdm-gtk-greeter"
PKGS6="lightdm-gtk-greeter-settings libjpeg-turbo8-dev libpam0g-dev"

if [ "$(whoami)" != "root" ]; then
  echo -e "${WHITE}"
  echo -e "${GREEN}You need ${RED}root${GREEN} privileges to run this script!"
  echo -e "${WHITE}"
  exec sudo -- "$0" "$@"
fi

echo -e "${GREEN}Running script.."
echo -e "${WHITE}"

sudo apt update > /dev/null 2>&1; sudo apt dist-upgrade -y > /dev/null 2>&1; sudo apt autoremove -y > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "sudo apt update; dist-upgrade; apt-autoremove ${GREEN}[OK]${WHITE}"
else
    echo -e "sudo apt update; dist-upgrade; apt-autoremove ${RED}[FAILED]${WHITE}"
fi

for pkg in $PKGS1 $PKGS2 $PKGS3 $PKGS4 $PKGS5 $PKGS6 ; do
  if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
      echo -e "Package skipped:   '$pkg' ${GREEN}[OK]${WHITE} (already installed)"
        else
          if sudo apt-get -qq install $pkg > /dev/null 2>&1; then
            echo -e "Package installed: '$pkg' ${GREEN}[OK]${WHITE}"
          else
            echo -e ""
            echo -e "Could not locate '$pkg', please install manually (see ${HOME}/NikoRice/AutoRice_Install.log)" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
            echo -e ""
          fi
  fi
done

wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh > /dev/null 2>&1; sh install.sh --unattended > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "wget Oh-My-ZSH and install ${GREEN}[OK]${WHITE}"
else
    echo -e "wget Oh-My-ZSH and install ${RED}[FAILED]${WHITE}" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

cd; cd NikoRice/RiceFiles > /dev/null 2>&1

cp -r baggrunde kommandoer.txt VPN .Xressources ${HOME}/
if [ $? -eq 0 ]; then
    echo -e "cp -r baggrunde kommandoer VPN .Xressources ${HOME}/${GREEN}[OK]${WHITE}"
else
    echo -e "cp -r baggrunde kommandoer VPN .Xressources ${HOME}/${RED}[FAILED]${WHITE}" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

if [ ! -d ${HOME}/.config/i3/ ]; then
    mkdir -p ${HOME}/.config/i3/;
    echo -e "Created needed dir '${HOME}/.config/i3/' ${GREEN}[OK]${WHITE}"
else
    echo -e "dir '${HOME}/.config/i3/' already exists. Skipping. ${GREEN}[OK]${WHITE}"
fi

cp -r config ${HOME}/.config/i3/ > /dev/null 2>&1; cp -r .config/scripts ${HOME}/.config/ > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "cp -r config ${HOME}/.config/i3/; cp -r .config/scripts ${HOME}/.config/ ${GREEN}[OK]${WHITE}"
else
    echo -e "cp -r config ${HOME}/.config/i3/; cp -r .config/scripts ${HOME}/.config/ ${RED}[FAILED]${WHITE}" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

sudo cp -r lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null 2>&1; sudo cp -r files-dell-bios-fan-control ${HOME}/ > /dev/null 2>&1; sudo cp -r i3status.conf /etc/ > /dev/null 2>&1; sudo cp -r i3lock /usr/local/bin/ > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "sudo cp lightdm-gtk-greeter.conf, files-dell-bios-fan-control, i3status.conf, i3lock ${GREEN}[OK]${WHITE}"
else
    echo -e "sudo cp lightdm-gtk-greeter.conf files-dell-bios-fan-control, i3status.conf, i3lock ${RED}[FAILED]${WHITE}" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi
cd

pip3 install pywal > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "pip3 install pywal ${GREEN}[OK]${WHITE}"
else
    echo -e "pip3 install pywal ${RED}[FAILED]${WHITE}" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

if [ ! -d ${HOME}/.zshrc ]; then
    sudo rm ${HOME}/.zshrc
    echo -e "Removed old dir '${HOME}/.zshrc' ${GREEN}[OK]${WHITE}"
else
    echo -e "Could not remove old dir '${HOME}/.zshrc' ${RED}[FAILED]${WHITE}" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

cd
cd NikoRice/RiceFiles > /dev/null 2>&1
cp -r .zshrc ${HOME}/
if [ $? -eq 0 ]; then
    echo -e "Move file '.zshrc --> ${HOME}/' ${GREEN}[OK]${WHITE}"
else
    echo -e "Move file '.zshrc --> ${HOME}/' ${RED}[FAILED]${WHITE}" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi
cd

xrdb ${HOME}/.Xressources > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "execute command 'xrdb ${HOME}/.Xressources' ${GREEN}[OK]${WHITE}"
else
    echo -e "execute command 'xrdb ${HOME}/.Xressources' ${RED}[FAILED]${WHITE}" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

wal -i ${HOME}/baggrunde/macro.png -a 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "execute command 'wal -i ${HOME}/baggrunde/macro.png -a 80' ${GREEN}[OK]${WHITE}"
else
    echo -e "execute command 'wal -i ${HOME}/baggrunde/macro.png -a 80' ${RED}[FAILED]${WHITE}" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

echo -e ""
read -p "Set ZSH as standard shell? (yes) (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
  while true; do
  echo -e ""
  echo "Enter password to set ZSH as std. shell"
  echo -e ""
  chsh -s $(which zsh) && break
  echo "Permission denied, try again"
  done
elif [[ $REPLY =~ ^[Nn]$ ]]; then
while true; do
  trap '' INT TSTP
  echo -e ""
  echo "Sike! You have no choice. Enter password to set ZSH as std. shell."
  echo -e ""
  chsh -s $(which zsh) && break
  echo "Permission denied, try again"
done
else
  while true; do
  echo -e ""
  echo -e "Enter password to set ZSH as std. shell"
  echo -e ""
  chsh -s $(which zsh) && break
  echo "Permission denied, try again"
  sleep 1
  done
fi

echo -e ""
read -p "Your Computer needs to reboot. Will you do it now? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e ""
        echo "Your computer will reboot in 5 seconds"
        echo -e ""
        sleep 5
        reboot
elif [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e ""
        echo "Please reboot your system later!"
        echo -e ""
        sleep 1
else
  echo -e ""
	echo "Please reboot your system later!"
  echo -e ""
  sleep 1
fi
