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

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

LISTMAX=1000

setopt extended_history
# HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "

setopt hist_reduce_blanks
setopt share_history

# export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'

alias ls='ls -GF'
alias ll='ls -l'

alias processing='open -a Processing'

alias cp='cp -i'
alias mv='mv -i'
alias unmount='diskutil unmount'
alias timestamp='date +%s.%N'
alias activate='source bin/activate'

alias history='history -E 1'
alias grep="grep --color"
alias sudo="sudo " #ローカルのエイリアスを反映させるため

# source ~/.git-completion.

# set PATH so it includes user's private bin if it exists

# local setting in MacBookAir
alias brew='env PATH=${PATH/\/Users\/yuta_oohigashi\/.pyenv\/shims:/} brew'
if [ -x "`which emacs 2>/dev/null`" ]; then
    EDITOR='emacs'
    alias vim='emacs'
    alias vimtutor='emacs /usr/local/share/emacs/24.4/etc/tutorials/TUTORIAL.ja'
fi
if [ -x "`which rmtrash 2>/dev/null`" ]; then
    alias rm='rmtrash'
    alias cleantrash='/bin/rm -rf $HOME/.Trash/*'
else
    if ! [ -d "$HOME/.Trash/" ];then
        mkdir $HOME/.Trash/
    fi
    alias rm='mv --backup=numbered --target-directory=${HOME}/.Trash'
fi

case "$TERM" in
    dumb | emacs)
        PROMPT="%m:%~> "
        unsetopt zle
        ;;
esac

if [ -f "$HOME/.zshrc_local" ];then
    . "$HOME/.zshrc_local"
fi

function loadpath() {
    libpath=${1:?"You have to specify a library path"}
    if [ -d "$libpath" ];then #ファイルの存在を確認
        PATH="$libpath:$PATH"
    fi
}

loadpath $HOME/.bin
loadpath $HOME/.pyenv/shims
loadpath $HOME/.rbenv/shims
loadpath $HOME/.julia/usr/bin

if [ -d "$HOME/.julia/libmxnet" ] ; then
    MXNET_HOME="$HOME/.julia/libmxnet"
fi
