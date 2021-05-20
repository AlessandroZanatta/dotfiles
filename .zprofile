#           _      
#   _______| |__   
#  |_  / __| '_ \  
#   / /\__ \ | | | 
#  /___|___/_| |_| 
#                  


# ----------------------- #
# -------- MISC --------- # 
# ----------------------- #

# Better welcome screen with pfetch!!
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
pfetch

# Do NOT kill child processes of the shell when the shell is killed
setopt NO_HUP

# -------------------------- #
# -------- SOURCES --------- # 
# -------------------------- #

# Aliases
source "$HOME/.zsh_aliases"

# Virtualenv
source /usr/bin/virtualenvwrapper.sh

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

# Add Cabal binaries to PATH
export PATH=$PATH:/home/kalex/.cabal/bin

# Add .local to PATH
export PATH=$PATH:/home/kalex/.local/bin

# Add GOPATH to env
export GOPATH=$HOME/Programs

# Add Android Emulator to PATH
export PATH=$PATH:/opt/android-sdk/emulator:/opt/android-sdk/tools/bin/

# HackNotes requires an EDITOR variable to be set
export EDITOR=nvim

# Virtualenv
# export PROJECT_HOME=$HOME/Projects
export WORKON_HOME=$HOME/.virtualenvs

# -------------------------- #
# ------- FUNCTIONS -------- # 
# -------------------------- #

# Docker utility for fast connection
docker_connect(){
    if [[ $# -eq 1 ]]; then
        docker exec -it $(docker ps | grep $1 | cut -d ' ' -f 1) /bin/bash; 
    else
        echo "Usage: $0"
    fi
}

# okular should start in background...
pdf(){ nohup okular "$1" > /dev/null & }


# Pandoc shortcut for a md to pdf render
md2pdf(){
        if [[ $# -eq 1 ]]; then
                pandoc -f markdown -t latex "$1" -o "${1%.md}.tex" -s --number-sections -V colorlinks=true -V linkcolor=blue -V urlcolor=red && pdflatex "${1%.md}.tex" && rm "${1%.md}.tex" "${1%.md}.aux" "${1%.md}.log"
        else
                echo 'Usage: md2tex input.md'
                # exit 2
        fi
}


# Easier init of pwndocker
pwndocker(){
        if [[ $# -eq 1 ]]; then
                docker run -d --rm -h $1 --name $1 -v "$(pwd)/$1":/ctf/work -p 23946:23946 --cap-add=SYS_PTRACE skysider/pwndocker
        else
                echo "Usage: pwndocker container_name"
        fi
}


# Clean swap
swap_clean(){
        sudo swapoff /dev/sda4
        sudo swapon /dev/sda4
}


# activate/deactivate >> workon/deactivate
activate(){
    if [[ $# -eq 1 ]]; then
       workon "$1" 
    else
        echo "Usage: $0 py-env"
        exit 1
    fi;
}


# Start background programs without output with ease
noout(){
    if [[ $# -ne 0 ]]; then
        nohup $@ > /dev/null &
    else
        echo "Usage: $0 program"
        exit 1
    fi;
}


# Download youtube videos' audio
youtube-download(){
    if [[ $# -eq 1 ]]; then 
        youtube-dl --no-overwrites --ignore-errors --yes-playlist -f bestaudio -o '/home/kalex/Music/%(title)s.%(ext)s' "$1"
    elif [[ $# -eq 2 ]]; then
        youtube-dl --no-overwrites --ignore-errors --yes-playlist -f bestaudio -o "$2/%(title)s.%(ext)s" "$1"
    else
        echo "Usage $0 youtube-url"
        exit 1
    fi;
}


# Convert symbol into unicode code
from_symbol(){
    if [[ $# -eq 1 ]]; then
        if [ ${#1} -eq 1 ]; then
            echo -n "$1" |              # -n ignore trailing newline
            iconv -f utf8 -t utf32be |  # UTF-32 big-endian happens to be the code point
            xxd -p |                    # -p just give me the plain hex
            sed -r 's/^0+/0x/' |        # remove leading 0's, replace with 0x
            xargs printf '\\x%04X\n'     # pretty print the code point
        else
            echo "Only single characters allowed!"
        fi
    else
        echo "Usage: $0 single-character"
        exit 1
    fi
}


# Activate/deactivate ASLR (very useful for pwn)
aslr(){
    if [[ $# -eq 1 ]]; then
        if [[ "$1" == "on" ]]; then
            echo "2" | sudo tee /proc/sys/kernel/randomize_va_space
        elif [[ "$1" == "off" ]]; then
            echo "0" | sudo tee /proc/sys/kernel/randomize_va_space
        else
            echo "Usage: $0 [on/off]"
        fi
    else
        echo "Usage: $0 [on/off]"
    fi
}


# Always run tamarin with this flag to avoid errors not showing up
# Notice: the flag --quit-on-warning must come after everything, an alias would break everything
tp(){
    /home/kalex/.local/bin/tamarin-prover $@ --quit-on-warning
}


# Proverif command
pv(){
    local OUT_DIR=${2:-out}
    if [ ! -d "$OUT_DIR" ]; then
        mkdir "$OUT_DIR"
    fi

    proverif -graph "$OUT_DIR" "$1"
} 

# Start GDB with given libc
gdb-libc(){
    if [[ $# -eq 2 ]]; then
        gdb -iex "set exec-wrapper env LD_PRELOAD=$1" "$2"
    else
        echo "Usage: $0 libc-to-preload patched-binary"
    fi
}

# Toggle my HomeVPN with wireguard
toggleVPN(){
    vpname=""
    if [[ $# -eq 1 ]]; then
        vpnname="$1"
    else
        vpnname="HomeVPN"
    fi
    
    vpnstatus=$(sudo wg show "$vpnname")
    if [[ $vpnstatus == "" ]]; then # Offline
        sudo wg-quick up "$vpnname"
    else # Online
        sudo wg-quick down "$vpnname"
    fi
}
