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

echo -e "${GREEN}Running script.. (Please be patient, this might take a while)"
echo -e "${WHITE}"
test1=8.8.8.8
test2=www.google.com

#Internet test
if nc -dzw1 $test1 443 && echo |openssl s_client -connect $test1:443 2>&1 |awk '
  handshake && $1 == "Verification" { if ($2=="OK") exit; exit 1 }
  $1 $2 == "SSLhandshake" { handshake = 1 }'
then
  echo "${GREEN}[  OK  ]${WHITE} Connection test: 8.8.8.8        up. Proceeding.."
else
  echo "${RED}[FAILED]${WHITE} Connection test: 8.8.8.8        down. Exiting.."
  exit 1
fi
if nc -dzw1 $test2 443 && echo |openssl s_client -connect $test2:443 2>&1 |awk '
  handshake && $1 == "Verification" { if ($2=="OK") exit; exit 1 }
  $1 $2 == "SSLhandshake" { handshake = 1 }'
then
  echo "${GREEN}[  OK  ]${WHITE} Connection test: www.google.com up. Proceeding.."
else
  echo "${RED}[FAILED]${WHITE} Connection test: www.google.com down. Exiting.."
  exit 1
fi

# Update
sudo apt-get update > /dev/null 2>&1; sudo apt-get dist-upgrade -y > /dev/null 2>&1; sudo apt-get autoremove -y > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} sudo apt update; dist-upgrade; apt-autoremove"
else
    echo -e "${RED}[FAILED]${WHITE} sudo apt update; dist-upgrade; apt-autoremove"
fi

#Install packages
for pkg in $PKGS1 $PKGS2 $PKGS3 $PKGS4 $PKGS5 $PKGS6 ; do
  if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
      echo -e "${GREEN}[  OK  ]${WHITE} Package skipped:   '$pkg' (already installed)"
        else
          if sudo apt-get -qq install $pkg > /dev/null 2>&1; then
            echo -e "${GREEN}[  OK  ]${WHITE} Package installed: '$pkg'"
          else
            echo -e ""
            echo -e "Could not locate '$pkg', please install manually (see ${HOME}/NikoRice/AutoRice_Install.log)" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
            echo -e ""
          fi
  fi
done

wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh > /dev/null 2>&1; sh install.sh --unattended > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} wget Oh-My-ZSH and install"
else
    echo -e "${RED}[FAILED]${WHITE} wget Oh-My-ZSH and install" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

cd; cd NikoRice/RiceFiles > /dev/null 2>&1

cp -r baggrunde kommandoer.txt VPN .Xressources ${HOME}/
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} cp -r baggrunde kommandoer VPN .Xressources ${HOME}/"
else
    echo -e "${RED}[FAILED]${WHITE} cp -r baggrunde kommandoer VPN .Xressources ${HOME}/" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

if [ ! -d ${HOME}/.config/i3/ ]; then
    mkdir -p ${HOME}/.config/i3/;
    echo -e "${GREEN}[  OK  ]${WHITE} Created needed dir '${HOME}/.config/i3/'"
else
    echo -e "${GREEN}[  OK  ]${WHITE} dir '${HOME}/.config/i3/' already exists. Skipping."
fi

cp -r config ${HOME}/.config/i3/ > /dev/null 2>&1; cp -r scripts ${HOME}/.config/ > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} cp -r config ${HOME}/.config/i3/; cp -r .config/scripts ${HOME}/.config/"
else
    echo -e "${RED}[FAILED]${WHITE} cp -r config ${HOME}/.config/i3/; cp -r .config/scripts ${HOME}/.config/" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

sudo cp -r lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null 2>&1; sudo cp -r files-dell-bios-fan-control ${HOME}/ > /dev/null 2>&1; sudo cp -r i3status.conf /etc/ > /dev/null 2>&1; sudo cp -r i3lock /usr/local/bin/ > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} sudo cp lightdm-gtk-greeter.conf, files-dell-bios-fan-control, i3status.conf, i3lock"
else
    echo -e "${RED}[FAILED]${WHITE} sudo cp lightdm-gtk-greeter.conf files-dell-bios-fan-control, i3status.conf, i3lock" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi
cd

pip3 install pywal > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} pip3 install pywal"
else
    echo -e "${RED}[FAILED]${WHITE} pip3 install pywal" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

if [ ! -d ${HOME}/.zshrc ]; then
    sudo rm ${HOME}/.zshrc
    echo -e "${GREEN}[  OK  ]${WHITE} Removed old dir '${HOME}/.zshrc'"
else
    echo -e "${RED}[FAILED]${WHITE} Could not remove old dir '${HOME}/.zshrc'" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

cd
cd NikoRice/RiceFiles > /dev/null 2>&1
cp -r .zshrc ${HOME}/
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} Move file '.zshrc --> ${HOME}/'"
else
    echo -e "${RED}[FAILED]${WHITE} Move file '.zshrc --> ${HOME}/'" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi
cd

xrdb ${HOME}/.Xressources > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} execute command 'xrdb ${HOME}/.Xressources'"
else
    echo -e "${RED}[FAILED]${WHITE} execute command 'xrdb ${HOME}/.Xressources'" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

wal -i ${HOME}/baggrunde/macro.png -a 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} execute command 'wal -i ${HOME}/baggrunde/macro.png -a 80'"
else
    echo -e "${RED}[FAILED]${WHITE} execute command 'wal -i ${HOME}/baggrunde/macro.png -a 80'" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
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
