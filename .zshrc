autoload -Uz select-word-style
select-word-style default

zstyle ':zle:*' word-chars " /-;@:{},|"
zstyle ':zle:*' word-style unspecified

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-chages true
zstyle ':vcs_info:*' stagedstr "+"
zstyle ':vcs_info:*' unstagedstr "*"
zstyle ':vcs_info:*' formats '(%b%c%u)'
zstyle ':vcs_info:*' actionformats '(%b(%a)%c%u)'

# プロンプト表示直前にvcs_info呼び出し
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
#add-zsh-hook precmd _update_vcs_info_msg
PROMPT=""
# PROMPT="%{${fg[green]}%}"
PROMPT+="%n%{${reset_color}%}"
PROMPT+="@%F{blue}%m%f"
PROMPT+="%1(v|%F{red}%1v%f|)"
# RPROMPT='%F{green}%d%f'
PROMPT+=':%F{green}%~%f'
PROMPT+="
(*'0'){ "

autoload -Uz colors
colors

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${LS_COLORS}"

setopt ignoreeof
setopt always_last_prompt
setopt auto_cd
function chpwd() { ls -lGF }
setopt equals
setopt complete_in_word

autoload -Uz compinit
compinit

setopt auto_list
setopt auto_menu
setopt list_packed
setopt list_types

bindkey -e

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

zle -N history-incremental-pattern-search-forward history-search-end
zle -N history-incremental-pattern-search-backword history-search-end

bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

bindkey "^R" history-incremental-pattern-search-backword
bindkey "^S" history-incremental-pattern-search-forward

# PROMPT="[%n@%m %~](*'0'){"

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

LISTMAX=1000

setopt extended_history
# HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "

setopt hist_reduce_blanks
setopt share_history

# export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'

# export PS1="\w (*'0'){ "
export PATH="$HOME/.pyenv/shims:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"

alias ls='ls -GF'
alias ll='ls -l'

# alias emacs='/usr/local/bin/emacs-24.4'
# alias vim='emacs'
# alias vimtutor='emacs /usr/local/share/emacs/24.4/etc/tutorials/TUTORIAL.ja'

alias processing='open -a Processing'

alias cleantrash='/bin/rm -rf .Trash/*'
alias cp='cp -i'
alias mv='mv -i'
alias unmount='diskutil unmount'
alias timestamp='python3 -c "import time;print(time.time())"'
alias activate='source bin/activate'

alias history='history -E 1'
alias grep="grep --color"
alias sudo="sudo "

# source ~/.git-completion.

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

# local setting in MacBookAir
alias brew='env PATH=${PATH/\/Users\/yuta_oohigashi\/.pyenv\/shims:/} brew'
export EDITOR='emacs-24.4'
alias rm='rmtrash'

case "$TERM" in
    dumb | emacs)
        PROMPT="%m:%~> "
        unsetopt zle
        ;;
esac

function exists { which $1 &> /dev/null }
exists
if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
        CURSOR=$#BUFFER # move cursor
        zle -R -c # refresh
    }

    zle -N percol_select_history
    bindkey '^R' percol_select_history
fi
