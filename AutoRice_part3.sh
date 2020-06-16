#!/bin/bash
PATH=$PATH:${HOME}/.local/bin

RED='\033[0;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'

echo -e ""
echo -e "Script needs root privileges for this one"
echo -e ""

cd "$(find ~/NikoRice/RiceFiles/ -name "lightdm-gtk-greeter.conf" -printf '%h' -quit)"
sudo cp -r lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} sudo cp -r lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf"
else
    echo -e "${RED}[FAILED]${WHITE} sudo cp -r lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf" | tee -a "~/NikoRice/AutoRice_Install.log"
fi
sudo cp -r i3status.conf /etc/
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} sudo cp -r i3status.conf /etc/"
else
    echo -e "${RED}[FAILED]${WHITE} sudo cp -r i3status.conf /etc/" | tee -a "~/NikoRice/AutoRice_Install.log"
fi
sudo cp -r i3lock /usr/local/bin/
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} sudo cp -r i3lock /usr/local/bin/"
else
    echo -e "${RED}[FAILED]${WHITE} sudo cp -r i3lock /usr/local/bin/" | tee -a "~/NikoRice/AutoRice_Install.log"
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
  echo "You have no choice. Enter password to set ZSH as std. shell."
  chsh -s $(which zsh) && break
  echo "Permission denied, try again"
done
else
  while true; do
  echo -e "Enter password to set ZSH as std. shell"
  chsh -s $(which zsh) && break
  echo "Permission denied, try again"
  sleep 1
  done
fi

echo -e ""
echo -e "Script has finished. System fully set!"
echo -e ""

read -p "Please reboot system to make final chances. Will you do it now? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Your computer will reboot in 5 seconds"
        sleep 5
        reboot
elif [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "Please reboot your system later!"
        sleep 1
else
  echo "Please reboot your system before you begin work!"
fi
