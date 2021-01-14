# Configurations!

source "$HOME/.config/user-dirs.dirs"

# Never misstype again!

alias ls='ls --color'

alias cl='clear; pfetch'
alias l=ls
alias s=ls
alias sl=ls

# Docker utility for fast connection
docker_connect(){
    if [[ $# -eq 1 ]]; then
        docker exec -it $(docker ps | grep $1 | cut -d ' ' -f 1) /bin/bash; 
    else
        echo "Usage: $0"
    fi
}


# Creating pwn scripts with a command!
alias pwninit='pwninit --template-path=/usr/local/bin/pwninit_template.py'


# okular should start in background...
pdf(){ nohup okular "$1" > /dev/null & }


# Pandoc shortcut for a md to pdf render
md2pdf(){
        if [[ $# -eq 1 ]]; then
                pandoc -f markdown -t latex "$1" -o "${1%.md}.tex" -s --number-sections && pdflatex "${1%.md}.tex" && rm "${1%.md}.tex" "${1%.md}.aux" "${1%.md}.log"
        else
                echo 'Usage: md2tex input.md'
                # exit 2
        fi
}

# Faster init of pwndocker
pwndocker(){
        if [[ $# -eq 1 ]]; then
                docker run -d --rm -h $1 --name $1 -v $(pwd)/$1:/ctf/work -p 23946:23946 --cap-add=SYS_PTRACE skysider/pwndocker
        else
                echo 'Usage: $0 container_name'
                exit 1
        fi;
}


# The fuck alias
eval "$(thefuck --alias)"


# volatility framework alias
alias "volatility"="vol.py"


# Add Android Emulator to PATH
export PATH=$PATH:/opt/android-sdk/emulator:/opt/android-sdk/tools/bin/
# This broke Clion (java version too hold), so switching to the alias!
# export JAVA_HOME=/opt/android-studio/jre
alias android='JAVA_HOME=/opt/android-studio/jre android-studio'

# Colored grep
alias grep='grep --color'


# Start with AMDGPU programs that are video intensive
alias teams='DRI_PRIME=1 nohup teams > /dev/null &'
alias discord='DRI_PRIME=1 nohup discord > /dev/null &' # This actually is pretty heavy on the GPU and makes it go over 70°C, should probably avoid!


# Clean swap
swap_clean(){
        sudo swapoff /dev/sda10
        sudo swapon /dev/sda10
}


# Cutter is bad, cutter is better
alias cutter=Cutter

# HackNotes EDITOR
export EDITOR=nvim

# Same for binaryninja
alias binaryninja='binaryninja-demo'

# NeoVim alias
alias vi=nvim
alias vim=nvim

# Start Clion in background without output
alias clion='nohup clion > /dev/null &'

# Start BurpSuite in background without output
alias burpsuite='nohup burpsuite > /dev/null &'

# A remainder!
# A reminder
function githelp {
    echo "-------------------------------------------------------------------------------"
    echo "git clone http://... [repo-name]"
    echo "git init [repo-name]"
    echo "-------------------------------------------------------------------------------"
    echo "git add -A <==> git add . ; git add -u # Add to the staging area (index)"
    echo "-------------------------------------------------------------------------------"
    echo "git commit -m 'message' -a"
    echo "git commit -m 'message' -a --amend"
    echo "-------------------------------------------------------------------------------"
    echo "git status"
    echo "git log --stat # Last commits, --stat optional"
    echo "git ls-files"
    echo "git diff HEAD~1..HEAD"
    echo "-------------------------------------------------------------------------------"
    echo "git push origin master"
    echo "git push origin master:master"
    echo "-------------------------------------------------------------------------------"
    echo "git remote add origin http://..."
    echo "git remote set-url origin git://..."
    echo "-------------------------------------------------------------------------------"
    echo "git stash"
    echo "git pull origin master"
    echo "git stash list ; git stash pop"
    echo "-------------------------------------------------------------------------------"
    echo "git submodule add /absolute/path repo-name"
    echo "git submodule add http://... repo-name"
    echo "-------------------------------------------------------------------------------"
    echo "git checkout -b new-branch <==> git branch new-branch ; git checkout new-branch"
    echo "git merge old-branch"
    echo "git branch local_name origin/remote_name # Associate branches"
    echo "-------------------------------------------------------------------------------"
    echo "git update-index --assume-unchanged <file> # Ignore changes"
    echo "git rm --cached <file> # Untrack a file"
    echo "-------------------------------------------------------------------------------"
    echo "git reset --hard HEAD # Repair what has been done since last commit"
    echo "git revert HEAD # Repair last commit"
    echo "git checkout [file] # Reset a file to its previous state at last commit"
    echo "-------------------------------------------------------------------------------"
    echo "git tag # List"
    echo "git tag v0.5 # Lightwieght tag"
    echo "git tag -a v1.4 -m 'my version 1.4' # Annotated tag"
    echo "git push origin v1.4 # Pushing"
    echo "-------------------------------------------------------------------------------"
    echo "HOW TO RENAME A BRANCH LOCALLY AND REMOTELY"
    echo "git branch -m old_name new_name"
    echo "git push origin new_name"
    echo "git push origin :old_name"
    echo "------"
    echo "Each other client of the repository has to do:"
    echo "git fetch origin ; git remote prune origin"
    echo "-------------------------------------------------------------------------------"
}

# Virtualenvwrapper things
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
source /usr/bin/virtualenvwrapper.sh

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

# Colored radeontop
alias radeontop='sudo radeontop -c'

# Do NOT kill child processes of the shell when the shell is killed
setopt NO_HUP

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

# Better welcome screen with pfetch!!
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
pfetch
