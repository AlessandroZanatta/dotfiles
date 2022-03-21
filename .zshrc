# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/kalex/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    autoupdate
    autojump
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Spaceship-prompt customization
# SPACESHIP_TIME_SHOW=true
# SPACESHIP_EXIT_CODE_SHOW=true
# 
# SPACESHIP_PROMPT_ORDER=(
#   user          # Username section
#   dir           # Current directory section
#   host          # Hostname section
#   git           # Git section (git_branch + git_status)
#   package       # Package version
#   node          # Node.js section
#   golang        # Go section
#   php           # PHP section
#   rust          # Rust section
#   haskell       # Haskell Stack section
#   docker        # Docker section
#   line_sep      # Line break
#   jobs          # Background jobs indicator
#   char          # Prompt character
# )
# 
# SPACESHIP_RPROMPT_ORDER=(
#   exit_code     # Exit code section
#   time          # Time stamps section
#   exec_time     # Execution time
# )

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# powerleve10k chosen theme
# source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

source "$HOME/.zprofile"

[[ -s /home/kalex/.autojump/etc/profile.d/autojump.sh ]] && source /home/kalex/.autojump/etc/profile.d/autojump.sh

autoload -U compinit && compinit -u

# opam configuration
[[ ! -r /home/kalex/.opam/opam-init/init.zsh ]] || source /home/kalex/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
