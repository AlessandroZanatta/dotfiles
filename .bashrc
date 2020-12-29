#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '


# Never misstype again!
alias cl=clear
alias l=ls
alias s=ls
alias sl=ls


# Powerline configuration
#if [ -f /usr/share/bash/powerline.sh ]; then
#    /usr/bin/powerline-daemon -q
#    POWERLINE_BASH_CONTINUATION=1
#    POWERLINE_BASH_SELECT=1
#    source /usr/share/bash/powerline.sh
#fi

# eval "$(starship init bash)"


# Docker utility for fast connection
docker_connect(){ docker exec -it $(docker ps | grep $1 | cut -d ' ' -f 1) /bin/bash; }


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

alias make_pdf='pandoc --from markdown --template eisvogel --listings --pdf-engine=xelatex'



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
export JAVA_HOME=/opt/android-studio/jre


# Colored grep
alias grep='grep --color'


# Start with AMDGPU programs that are video intensive
alias teams='DRI_PRIME=1 nohup teams > /dev/null &'
# alias discord='DRI_PRIME=1 nohup discord > /dev/null &' # This actually is pretty heavy on the GPU and makes it go over 70°C, should probably avoid!


# Clean swap
swap_clean(){
	sudo swapoff /dev/sda10
	sudo swapon /dev/sda10
}


# Cutter is bad, cutter is better
alias cutter=Cutter


# Same for binaryninja
alias binaryninja='binaryninja-demo'


# HackNotes editor
export EDITOR=nvim

neofetch
