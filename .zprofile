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

# -------------------------- #
# -------- SOURCES --------- # 
# -------------------------- #

# Aliases
source $HOME/.zsh_aliases

# Virtualenvwrapper
source virtualenvwrapper.sh

# -------------------------- #
# -------- EXPORTS --------- # 
# -------------------------- #

# XDG stuff
# export XDG_DESKTOP_DIR="$HOME/Desktop"
# export XDG_DOWNLOAD_DIR="$HOME/Downloads"
# export XDG_TEMPLATES_DIR="$HOME/Templates"
# export XDG_PUBLICSHARE_DIR="$HOME/Public"
# export XDG_DOCUMENTS_DIR="$HOME/Documents"
# export XDG_MUSIC_DIR="$HOME/Music"
# export XDG_PICTURES_DIR="$HOME/Pictures"
# export XDG_VIDEOS_DIR="$HOME/Videos"

# HackNotes requires an EDITOR variable to be set
export EDITOR=nvim

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
pdf(){ for pdf in "$@"; do nohup okular "$pdf" > /dev/null &; done }


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
    $HOME/.local/bin/tamarin-prover $@ --quit-on-warning
}


# Proverif command
pv(){
    local OUT_DIR=${2:-out}
    if [ ! -d "$OUT_DIR" ]; then
        mkdir "$OUT_DIR"
    fi

    proverif -color -graph "$OUT_DIR" "$1"
} 

# Create a summary latex starting file from template
summary(){
    red=`tput setaf 1`
    green=`tput setaf 2`
    reset=`tput sgr0`
    if [[ -d "$(pwd)/summary" ]]; then
       echo "${red}'Summary' directory already exists. Delete it to proceed.${reset}"
    else
        cp -r "/home/kalex/Projects/latex_summary_template" "$(pwd)/summary"
        echo "${green}Created summary correctly!${reset}"
        cd summary
    fi
}

pptx2pdf(){
    for pdf in "$@"; do soffice --headless --convert-to pdf "$pdf" > /dev/null &; done
}

xpp(){
    noout xournalpp "$1"
}

set_tablet_screen(){
    if [[ $# -eq 1 ]]; then
        MONITOR=${1}
        PAD_NAME='HUION Huion Tablet Pad'
        ID_STYLUS=`xinput | egrep "Pen|stylus" | cut -f 2 | cut -c 4-5`

        xinput map-to-output $ID_STYLUS $MONITOR
    else
        echo "Usage: $0 <screen name>"
    fi
}

rftoggle(){
    rfkill toggle all 
}

mvimg(){
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <image name>"
        return 1
    fi
    
    if [[ -d "images" ]]; then
        if [[ $(find "images" -iname "$1*") ]]; then
            echo -ne '\e[48;5;202mWarning\e[0m - file already exists in the image folder.\nProceed? (y/n): '
            read answer
            if [[ -z "$answer" ]] || [[ "$answer" == "n" ]]; then
                echo -e '\e[48;5;9mAborted\e[0m'
                return 1
            fi
        fi

        if [[ $(find "$HOME/Downloads" -iname "$1*") ]]; then
            mv $HOME/Downloads/$1* "images"
            echo -e '\e[48;5;22mDone!\e[0m'
        else
            echo -e '\e[48;5;9mAborted\e[0m - image not found in downloads!'
        fi
    else
        echo -e '\e[48;5;9mAborted\e[0m - images directory not found!'
    fi
}
