# exports
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/home/$(whoami)/.nix-profile/bin
export LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH

export QT_QPA_PLATFORMTHEME="gtk3"
export QT_STYLE_OVERRIDE="gtk3"

export XCURSOR_THEME="BreezeX-Light"
export XCURSOR_SIZE=24

ZSH_THEME="clean"

plugins=(git)

source $ZSH/oh-my-zsh.sh
. "$HOME/.cargo/env"

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
else
  echo 'zoxide: command not found, please install it from https://github.com/ajeetdsouza/zoxide'
fi

alias caps="setxkbmap -layout us,ru -option grp:caps_toggle"
alias docker="sudo docker"
alias c="clear"
alias ff="fastfetch"
alias random="./random"
alias hx="helix"
alias ranger="joshuto"
alias cd="z"
