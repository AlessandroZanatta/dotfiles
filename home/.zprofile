#           _
#   _______| |__
#  |_  / __| '_ \
#   / /\__ \ | | |
#  /___|___/_| |_|
#

# ----------------------- #
# -------- MISC --------- #
# ----------------------- #

# Do NOT kill child processes of the shell when the shell is killed
setopt NO_HUP

# SSH agent socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# -------------------------- #
# -------- SOURCES --------- #
# -------------------------- #

# Aliases
source $HOME/.zsh_aliases

# -------------------------- #
# -------- EXPORTS --------- #
# -------------------------- #

# XDG stuff
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"

# HackNotes requires an EDITOR variable to be set
export EDITOR="/usr/local/bin/v"

export GOPATH=""

# Add .local/bin to path, as `pip3 --user` installs in here
export PATH="$PATH:$HOME/.local/bin"

# Add personal scripts to PATH
export PATH="$PATH:$HOME/dotfiles/scripts"

# Add GOPATH to PATH
export PATH="$PATH:$HOME/go/bin"

# Add cargo binaries to PATH
export PATH="$PATH:$HOME/.cargo/bin"

# Add android sdkmanager and emulator
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"

# chroot path for testing AUR packages
export CHROOT="$HOME/chroot"

# -------------------------- #
# ------- FUNCTIONS -------- #
# -------------------------- #

# Docker utility
docker_connect() {
  if [[ $# -eq 1 ]]; then
    docker exec -it $(docker ps | grep $1 | cut -d ' ' -f 1) /bin/bash
  else
    echo "Usage: $0 container-name"
  fi
}

# evince should start in background...
pdf() { for pdf in "$@"; do nohup evince "$pdf" > /dev/null & done }

# activate/deactivate >> workon/deactivate
activate() {
  if [[ $# -eq 1 ]]; then
    workon "$1"
  else
    echo "Usage: $0 <py-env>"
    exit 1
  fi
}

# Start background programs without output with ease
noout() {
  if [[ $# -ne 0 ]]; then
    nohup $@ > /dev/null &
  else
    echo "Usage: $0 <program>"
    exit 1
  fi
}

xpp() {
  noout xournalpp "$1"
}

function kmerge() {
  if [ $# -eq 0 ]; then
     echo "Please pass the location of the kubeconfig you wish to merge"
  fi
  KUBECONFIG=~/.kube/config:$1 kubectl config view --flatten > ~/.kube/mergedkub && mv ~/.kube/mergedkub ~/.kube/config
}

