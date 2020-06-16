#!/bin/bash
PATH=$PATH:${HOME}/.local/bin

RED='\033[0;31m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'

if [ "$(whoami)" == "root" ]; then
  echo -e "${WHITE}"
  echo -e "${GREEN}Please do not run this script as ${RED}root${GREEN}!"
  echo -e "${WHITE}"
  exit
fi

wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh; sh install.sh --unattended 2>&1

cd "$(find ~/NikoRice/RiceFiles/ -name "lightdm-gtk-greeter.conf" -printf '%h' -quit)"

cp -r baggrunde kommandoer.txt VPN .Xressources ~/
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} cp -r baggrunde kommandoer VPN .Xressources ~/"
else
    echo -e "${RED}[FAILED]${WHITE} cp -r baggrunde kommandoer VPN .Xressources ~/" | tee -a "~/NikoRice/AutoRice_Install.log"
fi

if [[ $(find /home/ -path ~/NikoRice -prune -o -name ".config" | grep ".config") != null ]]; then
    mkdir -p ~/.config/i3/
    echo -e "${GREEN}[  OK  ]${WHITE} Created needed dir '~/.config/i3/'"
else
    echo -e "${GREEN}[  OK  ]${WHITE} dir '~/.config/i3/' already exists. Skipping."
fi

cp -r config ~/.config/i3/; cp -r scripts ~/.config/; cp -r files-dell-bios-fan-control ~/
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} cp -r config ~/.config/i3/; cp -r .config/scripts ~/.config/; cp -r files-dell-bios-fan-control ~/"
else
    echo -e "${RED}[FAILED]${WHITE} cp -r config ~/.config/i3/; cp -r .config/scripts ~/.config/; cp -r files-dell-bios-fan-control ~/" | tee -a "~/NikoRice/AutoRice_Install.log"
fi

cd "$(find ~/NikoRice/RiceFiles/ -name "lightdm-gtk-greeter.conf" -printf '%h' -quit)"

cd

pip3 install pywal
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} pip3 install pywal"
else
    echo -e "${RED}[FAILED]${WHITE} pip3 install pywal" | tee -a "~/NikoRice/AutoRice_Install.log"
fi

rm $(find /home/ -path ~/NikoRice -prune -o -name ".zshrc" | grep ".zshrc")
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} Removed old dir '~/.zshrc'"
else
    echo -e "${RED}[FAILED]${WHITE} Could not remove old dir '~/.zshrc'" | tee -a "~/NikoRice/AutoRice_Install.log"
fi

cd "$(find ~/NikoRice/RiceFiles/ -name ".zshrc" -printf '%h' -quit)"

cp -r .zshrc ~/
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} Move file '.zshrc --> ~/'"
else
    echo -e "${RED}[FAILED]${WHITE} Move file '.zshrc --> ~/'" | tee -a "~/NikoRice/AutoRice_Install.log"
fi

echo -e ""
echo -e "Script will now set xrdb and setup wal.."
echo -e ""
sleep 5

xrdb ~/.Xressources
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} execute command 'xrdb ~/.Xressources'"
else
    echo -e "${RED}[FAILED]${WHITE} execute command 'xrdb ~/.Xressources'" | tee -a "~/NikoRice/AutoRice_Install.log"
fi

wal -i ~/baggrunde/macro.png -a 80
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} execute command 'wal -i ~/baggrunde/macro.png -a 80'"
else
    echo -e "${RED}[FAILED]${WHITE} execute command 'wal -i ~/baggrunde/macro.png -a 80'" | tee -a "~/NikoRice/AutoRice_Install.log"
fi

read -p "Reboot system before running 'AutoRice_part3.sh'. Will you do it now? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Your computer will reboot in 5 seconds"
        sleep 5
        reboot
elif [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "Please reboot your system later!"
        sleep 1
else
  echo "Please reboot your system before running part 3!"
fi
