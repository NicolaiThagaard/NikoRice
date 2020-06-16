#!/bin/bash
PATH=$PATH:${HOME}/.local/bin

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
  exec sudo bash -- "$0" "$@"
fi

echo -e "${GREEN}Running script.. (Please be patient, this might take a while)"
echo -e "${WHITE}"

#Internet connectivity test
test1=8.8.8.8
test2=www.google.com

if nc -dzw1 $test1 443 && echo | openssl s_client -connect $test1:443 2>&1 |awk '
  handshake && $1 == "Verification" { if ($2=="OK") exit; exit 1 }
  $1 $2 == "SSLhandshake" { handshake = 1 }'
then
  echo "Connection test: 8.8.8.8 up. Proceeding.."
  echo -e "${WHITE}"
else
  echo "Connection test: 8.8.8.8 down. Exiting.."
  exit 1
fi
if nc -dzw1 $test2 443 && echo | openssl s_client -connect $test2:443 2>&1 |awk '
  handshake && $1 == "Verification" { if ($2=="OK") exit; exit 1 }
  $1 $2 == "SSLhandshake" { handshake = 1 }'
then
  echo "Connection test: www.google.com up. Proceeding.."
  echo -e "${WHITE}"
else
  echo "Connection test: www.google.com down. Exiting.."
  exit 1
fi

# Update
sudo apt-get update; sudo apt-get dist-upgrade -y; sudo apt-get autoremove -y
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[  OK  ]${WHITE} sudo apt update; dist-upgrade; apt-autoremove"
else
    echo -e "${RED}[FAILED]${WHITE} sudo apt update; dist-upgrade; apt-autoremove"
fi

#Install packages
for pkg in $PKGS1 $PKGS2 $PKGS3 $PKGS4 $PKGS5 $PKGS6 ; do
  if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$"; then
      echo -e "${GREEN}[  OK  ]${WHITE} Package skipped:   '$pkg' (already installed)"
      sleep 2
        else
          if sudo apt-get -qq install $pkg; then
            echo -e "${GREEN}[  OK  ]${WHITE} Package installed: '$pkg'"
            sleep 2
          else
            echo -e ""
            echo -e "Could not locate '$pkg', please install manually (see ~/NikoRice/AutoRice_Install.log)" | tee -a "~/NikoRice/AutoRice_Install.log"
            echo -e ""
            sleep 5
          fi
  fi
done

echo -e ""
echo -e "Run 'AutoRice_part2.sh' to finish install"
echo -e ""
