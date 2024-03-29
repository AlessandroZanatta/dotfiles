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

# thefuck setup
eval $(thefuck --alias)

# opam configuration
[[ ! -r /home/kalex/.opam/opam-init/init.zsh ]] || source /home/kalex/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# -------------------------- #
# -------- SOURCES --------- #
# -------------------------- #

# Aliases
source $HOME/.zsh_aliases

# Virtualenvwrapper
source virtualenvwrapper.sh

# debuginfod (needed by valgrind)
source /etc/profile.d/debuginfod.sh

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

# Chromium depot tools
export PATH="$PATH:/opt/depot_tools"

# Add in front to prevent shadowing
export PATH="/opt/pvs:$PATH"

# Solana
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

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

# Pandoc shortcut for a md to pdf render
md2pdf() {
  if [[ $# -gt 0 ]]; then
    pandoc -f markdown -t latex "$1" -o "${1%.md}.tex" -s --number-sections -V colorlinks=true -V linkcolor=blue -V urlcolor=red ${@:2} && pdflatex "${1%.md}.tex" && rm "${1%.md}.tex" "${1%.md}.aux" "${1%.md}.log"
  else
    echo 'Usage: md2tex input.md [additional flags]'
    exit 1
  fi
}

# Easier init of pwndocker
pwndocker() {
  if [[ $# -eq 1 ]]; then
    docker run -d --rm -h $1 --name $1 -v "$(pwd)/$1":/ctf/work -p 23946:23946 --cap-add=SYS_PTRACE skysider/pwndocker
  else
    echo "Usage: pwndocker <container_name>"
    exit 1
  fi
}

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

# Convert symbol into unicode code
# from_symbol(){
#     if [[ $# -eq 1 ]]; then
#         if [ ${#1} -eq 1 ]; then
#             echo -n "$1" |              # -n ignore trailing newline
#             iconv -f utf8 -t utf32be |  # UTF-32 big-endian happens to be the code point
#             xxd -p |                    # -p just give me the plain hex
#             sed -r 's/^0+/0x/' |        # remove leading 0's, replace with 0x
#             xargs printf '\\x%04X\n'     # pretty print the code point
#         else
#             echo "Only single characters allowed!"
#         fi
#     else
#         echo "Usage: $0 single-character"
#         exit 1
#     fi
# }

# Activate/deactivate ASLR only for a new shell (and its children)
local_aslr() {
  setarch $(uname -m) -R $SHELL
}

# Activate/deactivate ASLR
# aslr() {
#   if [[ $# -eq 1 ]]; then
#     if [[ "$1" == "on" ]]; then
#       echo "2" | sudo tee /proc/sys/kernel/randomize_va_space
#     elif [[ "$1" == "off" ]]; then
#       echo "0" | sudo tee /proc/sys/kernel/randomize_va_space
#     else
#       echo "Usage: $0 [on/off]"
#     fi
#   else
#     echo "Usage: $0 [on/off]"
#   fi
# }

# Proverif command
pv() {
  local OUT_DIR=${2:-out}
  if [ ! -d "$OUT_DIR" ]; then
    mkdir "$OUT_DIR"
  fi

  proverif -color -graph "$OUT_DIR" "$1"
}

# Create a summary latex starting file from template
summary() {
  red=$(tput setaf 1)
  green=$(tput setaf 2)
  reset=$(tput sgr0)
  if [[ -d "$(pwd)/summary" ]]; then
    echo "${red}'Summary' directory already exists. Delete it to proceed.${reset}"
  else
    cp -r "$HOME/Projects/latex_summary_template" "$(pwd)/summary"
    echo "${green}Created summary correctly!${reset}"
    cd summary
  fi
}

pptx2pdf() {
  for pdf in "$@"; do soffice --headless --convert-to pdf "$pdf" > /dev/null & done
}

xpp() {
  noout xournalpp "$1"
}

set_tablet_screen() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <screen name>"
    exit 1
  fi
  
  TABLET_NAME='Huion H430P'
  MONITOR="$1"

  # These setting assume my double monitor setup,
  # with the exact xrandr settings I'm using
  if [[ "$MONITOR" == "HDMI1" ]]; then
    otd setdisplayarea "$TABLET_NAME" 1920 1080 2326 540
  elif [[ "$MONITOR" == "eDP1" ]]; then
    otd setdisplayarea "$TABLET_NAME" 1366 768 683 540
  else
    echo "Monitor not found!"
    exit 1
  fi
}

# mvimg() {
#   if [[ $# -ne 1 ]]; then
#     echo "Usage: $0 <image name>"
#      exit 1
#   fi
#
#   red=$(tput setaf 1)
#   green=$(tput setaf 2)
#   ylw=$(tput setaf 3)
#   rst=$(tput sgr0)
#
#
#   if [[ -d "images" ]]; then
#     if [[ $(find "images" -iname "$1*") ]]; then
#       echo -ne "${ylw}Warning${rst} - file already exists in the image folder.\nProceed? (y/n): "
#       read answer
#       if [[ -z "$answer" ]] || [[ "$answer" == "n" ]]; then
#         echo -e "${red}Aborted${rst}"
#         exit 1
#       fi
#     fi
#
#     if [[ $(find "$HOME/Downloads" -iname "$1*") ]]; then
#       mv $HOME/Downloads/$1* "images"
#       echo -e "${green}Done!${rst}"
#     else
#       echo -e "${red}Aborted$}rst} - image not found in downloads!"
#     fi
#   else
#     echo -e "${red}Aborted${rst} - images directory not found!"
#   fi
# }

yt_download() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <youtube_url> [other flags]"
    exit 1
  fi

  yt-dlp -x --audio-format mp3 --add-metadata --write-thumbnail ${@:2} "$1"
}

dup_screen() {
  xrandr --output eDP-1 --mode 2560x1600 --output HDMI-1-1 --primary --scale-from 2560x1600 --same-as eDP-1
}

cs() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 path"
    return 
  fi
  checksec --file=$1 
}

export PATH="/home/kalex/.local/share/solana/install/active_release/bin:$PATH"
