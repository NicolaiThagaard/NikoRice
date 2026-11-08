# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

PATH="${PATH}:/usr/local/bin"
export PATH
ZSH_THEME="darkblood"

plugins=(git)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

alias U="sudo apt update; sudo apt upgrade -y; sudo apt autoremove -y"
alias vtop="$HOME/node_modules/vtop/bin/vtop.js"
alias VPN="cd \"$HOME/VPN\" && sudo openvpn \"$HOME/VPN/Netherlands.ovpn\""

function LOOP {
  while :; do
    "$@"
    sleep 0.5
  done
}

function x {
  if [[ $# -eq 0 ]]; then
    echo "Usage: x <archive> [archive ...]"
    return 1
  fi
  local n
  for n in "$@"; do
    if [[ ! -f "$n" ]]; then
      echo "'$n' - file does not exist"
      return 1
    fi
    case "$n" in
      *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) tar xvf "$n" ;;
      *.lzma) unlzma "./$n" ;;
      *.bz2) bunzip2 "./$n" ;;
      *.rar) unrar x -ad "./$n" ;;
      *.gz) gunzip "./$n" ;;
      *.zip) unzip "./$n" ;;
      *.z) uncompress "./$n" ;;
      *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar) 7z x "./$n" ;;
      *.xz) unxz "./$n" ;;
      *.exe) cabextract "./$n" ;;
      *) echo "extract: '$n' - unknown archive method"; return 1 ;;
    esac
  done
}
