#  ╔═══════════════════════════════════════════════════════════════╗
#  ║  Quant BSPWM - Zsh Configuration                            ║
#  ║  Plugin manager: zinit                                       ║
#  ╚═══════════════════════════════════════════════════════════════╝

# ── XDG ───────────────────────────────────────────────────────────

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# ── Environment ───────────────────────────────────────────────────

export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"
export MANPAGER="nvim +Man!"
export PAGER="less"
export LESS="-RFX --mouse"

# PATH
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/scripts"
    "$HOME/.npm-global/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.local/share/gem/ruby/*/bin"(N)
    $path
)
export PATH

# Input method (fcitx5)
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx

# Java BSPWM fix
export _JAVA_AWT_WM_NONREPARENTING=1

# ── History ───────────────────────────────────────────────────────

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

mkdir -p "$(dirname "$HISTFILE")"

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# ── Options ───────────────────────────────────────────────────────

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CORRECT
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt GLOB_DOTS
setopt EXTENDED_GLOB
setopt NUMERIC_GLOB_SORT

# ── Completion ────────────────────────────────────────────────────

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:*:*:descriptions' format '%F{#c4a7e7}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{#f9e2af}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{#cba6f7} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{#f38ba8}-- no matches --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Cache completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# ── Zinit Plugin Manager ──────────────────────────────────────────

ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
    print -P "%F{#f5c2e7}Installing zinit...%f"
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" 2>/dev/null
fi

source "${ZINIT_HOME}/zinit.zsh"

# Syntax highlighting
zinit light zsh-users/zsh-syntax-highlighting

# Autosuggestions
zinit light zsh-users/zsh-autosuggestions

# Completions
zinit light zsh-users/zsh-completions

# History substring search
zinit light zsh-users/zsh-history-substring-search

# Forgit (interactive git)
zinit light wfxr/forgit

# Fzf-tab (fzf-powered completion)
zinit light Aloxaf/fzf-tab

# ── Plugin Configuration ──────────────────────────────────────────

# Syntax highlighting colors (Quant palette)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[default]='fg=#e0def4'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#cba6f7,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[function]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a6e3a1,italic'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#fab387,italic'
ZSH_HIGHLIGHT_STYLES[path]='fg=#fab387,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#c4a7e7'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#94e2d5'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#94e2d5'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#94e2d5'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#94e2d5'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#e0def4'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#f5c2e7,bold'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6e6a86,italic'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#e0def4'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#e0def4'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#a6e3a1'

# Brackets
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=#f38ba8,bold'

# Autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6e6a86"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# History substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#2a2837,fg=#f5c2e7,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=#2a2837,fg=#f38ba8,bold'

# Fzf-tab
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null || ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null || ls -1 --color=always $realpath'

# ── Vi Mode ───────────────────────────────────────────────────────

bindkey -v
export KEYTIMEOUT=1

# Keep some emacs bindings in insert mode
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^W' backward-kill-word
bindkey '^U' backward-kill-line
bindkey '^R' history-incremental-search-backward
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# ── FZF ───────────────────────────────────────────────────────────

if command -v fzf &>/dev/null; then
    export FZF_DEFAULT_OPTS="
        --height=60%
        --layout=reverse
        --border=rounded
        --margin=0,1
        --padding=0,1
        --info=inline-right
        --prompt='  '
        --pointer=''
        --marker='+'
        --separator='~'
        --scrollbar='|'
        --color=bg+:#2a2837
        --color=bg:#16141f
        --color=border:#2a2837
        --color=fg:#e0def4
        --color=gutter:#16141f
        --color=header:#89b4fa
        --color=hl+:#f5c2e7
        --color=hl:#c4a7e7
        --color=info:#6e6a86
        --color=marker:#a6e3a1
        --color=pointer:#f5c2e7
        --color=prompt:#f5c2e7
        --color=query:#e0def4
        --color=scrollbar:#2a2837
        --color=separator:#2a2837
        --color=spinner:#f5c2e7
    "

    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

    # Preview commands
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:300 {} 2>/dev/null || cat {}'"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons --level=2 {} 2>/dev/null || tree -C -L 2 {}'"

    # Source fzf keybindings
    [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
    [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
fi

# ── Aliases ───────────────────────────────────────────────────────

# Core replacements
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first --git'
    alias la='eza -a --icons --group-directories-first'
    alias lt='eza --tree --icons --level=3 --group-directories-first'
    alias l='eza -l --icons --group-directories-first'
else
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -la --color=auto'
    alias la='ls -a --color=auto'
    alias l='ls -l --color=auto'
fi

command -v bat &>/dev/null && alias cat='bat --paging=never'
command -v fd &>/dev/null && alias find='fd'
command -v rg &>/dev/null && alias grep='rg'
command -v dust &>/dev/null && alias du='dust'
command -v duf &>/dev/null && alias df='duf'
command -v btop &>/dev/null && alias top='btop'
command -v procs &>/dev/null && alias ps='procs'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# Safety nets
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'
alias ln='ln -iv'

# Editors
alias v='nvim'
alias vim='nvim'
alias vi='nvim'
alias sv='sudo nvim'

# Git
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch --all --prune'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all'
alias gp='git push'
alias gpl='git pull --rebase'
alias gst='git status -sb'
alias gsw='git switch'
alias gswc='git switch -c'
alias lg='lazygit'

# Pacman / yay
alias pac='sudo pacman'
alias pacs='sudo pacman -S'
alias pacr='sudo pacman -Rns'
alias pacu='sudo pacman -Syu'
alias pacq='pacman -Qs'
alias pacsi='pacman -Si'
alias pacql='pacman -Ql'
alias pacorph='sudo pacman -Rns $(pacman -Qdtq)'
alias pacc='sudo pacman -Scc'

if command -v yay &>/dev/null; then
    alias yas='yay -S'
    alias yau='yay -Syu'
    alias yaq='yay -Qs'
    alias yasi='yay -Si'
fi

# System
alias sctl='sudo systemctl'
alias jctl='journalctl -xe'
alias reload='source ~/.zshrc && echo "Zsh reloaded"'
alias path='echo $PATH | tr ":" "\n" | nl'
alias myip='curl -s ifconfig.me && echo'
alias localip='ip -4 addr show | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | grep -v 127.0.0.1'
alias ports='ss -tulpn'
alias weather='curl "wttr.in/Surabaya?format=3"'
alias meminfo='free -h --si'
alias cpuinfo='lscpu | head -20'
alias gpuinfo='nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu,memory.used,memory.total --format=csv,noheader 2>/dev/null || echo "No NVIDIA GPU"'

# BSPWM
alias bspr='bspc wm -r && echo "BSPWM reloaded"'
alias bspn='bspc query -N -d focused'
alias bspd='bspc query -D --names'
alias polyreload='$HOME/.config/polybar/launch.sh'

# Clipboard
alias clip='xclip -selection clipboard'
alias clipo='xclip -selection clipboard -o'

# Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source ./venv/bin/activate 2>/dev/null || source ./.venv/bin/activate 2>/dev/null || echo "No venv found"'

# Files
alias yy='yazi'
alias ff='thunar . &>/dev/null &'

# Quick config edits
alias zshrc='nvim ~/.zshrc'
alias bsprc='nvim ~/.config/bspwm/bspwmrc'
alias sxhrc='nvim ~/.config/sxhkd/sxhkdrc'
alias polyrc='nvim ~/.config/polybar/config.ini'
alias picomrc='nvim ~/.config/picom/picom.conf'
alias kittyrc='nvim ~/.config/kitty/kitty.conf'
alias nvimrc='nvim ~/.config/nvim/init.lua'
alias tmuxrc='nvim ~/.config/tmux/tmux.conf'

# ── Functions ─────────────────────────────────────────────────────

# Create and cd into directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"      ;;
            *.tar.gz)   tar xzf "$1"      ;;
            *.tar.xz)   tar xJf "$1"      ;;
            *.tar.zst)  tar --zstd -xf "$1" ;;
            *.bz2)      bunzip2 "$1"      ;;
            *.rar)      unrar x "$1"      ;;
            *.gz)       gunzip "$1"       ;;
            *.tar)      tar xf "$1"       ;;
            *.tbz2)     tar xjf "$1"      ;;
            *.tgz)      tar xzf "$1"      ;;
            *.zip)      unzip "$1"        ;;
            *.Z)        uncompress "$1"   ;;
            *.7z)       7z x "$1"         ;;
            *)          echo "Cannot extract '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick note
note() {
    local notes_dir="$HOME/Documents/notes"
    mkdir -p "$notes_dir"
    if [[ -n "$1" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M') | $*" >> "$notes_dir/quick.md"
        echo "Note saved."
    else
        nvim "$notes_dir/quick.md"
    fi
}

# Git commit with timestamp
gcmsg() {
    git commit -m "$1 [$(date '+%Y-%m-%d %H:%M')]"
}

# Search and open file in nvim
fvim() {
    local file
    file=$(fzf --preview 'bat --color=always --style=numbers {}' --query="$1")
    [[ -n "$file" ]] && nvim "$file"
}

# Colored man pages
man() {
    LESS_TERMCAP_mb=$'\e[1;31m' \
    LESS_TERMCAP_md=$'\e[1;36m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[1;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[1;32m' \
    command man "$@"
}

# Quick calculator
calc() {
    python3 -c "from math import *; print($*)"
}

# ── Zoxide (smart cd) ────────────────────────────────────────────

if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
fi

# ── Starship Prompt ───────────────────────────────────────────────

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# ── Welcome ───────────────────────────────────────────────────────

if [[ -o interactive ]] && command -v neofetch &>/dev/null; then
    neofetch --config "$HOME/.config/neofetch/config.conf" 2>/dev/null
fi
