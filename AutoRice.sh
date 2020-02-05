#!/bin/bash

#CTRL+c detector function
ctrlc_count=0
function no_ctrlc()
{
    let ctrlc_count++
    echo
    if [[ $ctrlc_count == 1 ]]; then
        echo ""
        echo "You hit CTRL+c. Quitting script.. :-("
        echo ""
        exit 1
    fi
}

#Set CTRL+c trap througout script
trap no_ctrlc SIGINT

#Failure/OK colors
RED='\033[0;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'

#Packeages to install
PKGS1="git feh xorg lightdm python3-pip fonts-hack-ttf i3 virtualbox"
PKGS2="i3lock rar unrar compton zsh chromium-browser rofi neofetch scrot arandr"
PKGS3="imagemagick rxvt-unicode libev-dev libxcb-composite0 libxcb-composite0-dev"
PKGS4="libxcb-xinerama0 libxcb-randr0 libxcb-xinerama0-dev zip unzip libxcb-xkb-dev"
PKGS5="libxcb-image0-dev libxcb-util-dev libxkbcommon-x11-dev lightdm-gtk-greeter"
PKGS6="lightdm-gtk-greeter-settings libjpeg-turbo8-dev libpam0g-dev"

#Check if root
if [ "$(whoami)" != "root" ]; then
  echo -e "${WHITE}"
  echo -e "${GREEN}You need ${RED}root${GREEN} privileges to run this script!"
  echo -e "${WHITE}"
  exec sudo -- "$0" "$@"
fi

echo -e "${GREEN}Running script.. (Please be patient, this might take a while)"
echo -e "${WHITE}"

#Internet connectivity test
test1=8.8.8.8
test2=www.archive.ubuntu.com

if nc -dzw1 $test1 443 && echo |openssl s_client -connect $test1:443 2>&1 |awk '
  handshake && $1 == "Verification" { if ($2=="OK") exit; exit 1 }
  $1 $2 == "SSLhandshake" { handshake = 1 }'
then
  echo -e "[  OK  ] Connection test: 8.8.8.8 up. Proceeding.."
else
  echo -e "[FAILED] Connection test: 8.8.8.8 down. Exiting.." | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
  echo -e "         Please check your DNS settings before proceeding" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
  exit 1
fi
if nc -dzw1 $test2 80 && echo |openssl s_client -connect $test2:80 2>&1 |awk '
  handshake && $1 == "Verification" { if ($2=="OK") exit; exit 1 }
  $1 $2 == "SSLhandshake" { handshake = 1 }'
then
  echo -e "[  OK  ] Connection test: www.archive.ubuntu.com up. Proceeding.."
else
  echo -e "[FAILED] Connection test: www.archive.ubuntu.com down. Exiting.." | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
  echo -e "         HTTPS request failed, please resolve before proceeding." | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
  exit 1
fi

echo -e ""
echo -e "Webtest complete. Proceeding script.."
echo -e ""

# Update
sudo apt-get update > /dev/null 2>&1; sudo apt-get dist-upgrade -y > /dev/null 2>&1; sudo apt-get autoremove -y > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} sudo apt update; dist-upgrade; apt-autoremove"
else
    echo -e "${RED}[FAILED]${WHITE} sudo apt update; dist-upgrade; apt-autoremove" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
    echo -e "Error: Cannot update system. Try manually running:" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
    echo -e "sudo apt-get update" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
    echo -e "sudo apt-get dist-upgrade" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
    echo -e "(a reboot usually resolves the issue)." | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
    echo -e "Resolve the issue before continuuing. Exiting.." | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
    exit 1
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

#Install Oh-My-ZSH
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh > /dev/null 2>&1; sh install.sh --unattended > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} wget Oh-My-ZSH and install"
else
    echo -e "${RED}[FAILED]${WHITE} wget Oh-My-ZSH and install (already installed?)" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

#Move stuff
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

#Install Pywal
pip3 install pywal > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} pip3 install pywal"
else
    echo -e "${RED}[FAILED]${WHITE} pip3 install pywal" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

#Move stuff
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

#Set XRDB
xrdb ${HOME}/.Xressources > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} execute command 'xrdb ${HOME}/.Xressources'"
else
    echo -e "${RED}[FAILED]${WHITE} execute command 'xrdb ${HOME}/.Xressources'" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

#Set Background image
wal -i ${HOME}/baggrunde/macro.png -a 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} execute command 'wal -i ${HOME}/baggrunde/macro.png -a 80'"
else
    echo -e "${RED}[FAILED]${WHITE} execute command 'wal -i ${HOME}/baggrunde/macro.png -a 80'" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

#Set zsh as default shell
sudo chsh -s $(which zsh)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} execute command 'chsh -s $(which zsh)'"
else
    echo -e "${RED}[FAILED]${WHITE} execute command 'chsh -s $(which zsh)'" | tee -a "${HOME}/NikoRice/AutoRice_Install.log"
fi

#Stop the CTRL-c trap
trap - SIGINT

#Ask to reboot
echo -e ""
read -p "Your Computer needs to reboot. Will you do it now? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e ""
        echo "Your computer will reboot in 5 seconds"
        echo -e ""
        echo -e "Run this script again at reboot to check everything is OK"
        echo -e ""
        sleep 5
        reboot
elif [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e ""
        echo "Please reboot your system later!"
        echo -e ""
        echo -e "Run this script again at reboot to check everything is OK"
        echo -e ""
        sleep 1
else
  echo -e ""
	echo "Please reboot your system later!"
  echo -e ""
  echo -e "Run this script again at reboot to check everything is OK"
  echo -e ""
  sleep 1
fi
