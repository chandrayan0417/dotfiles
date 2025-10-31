# Aliases
#
# ls → eza -lh --group-directories-first --icons=auto
# lsa → ls -a
# lt → eza --tree --level=2 --long --icons --git
# lta → lt -a
# ff → fzf --preview 'bat --style=numbers --color=always {}'
# .. → cd ..
# ... → cd ../..
# .... → cd ../../..
# g → git
# d → docker
# r → rails
# gcm → git commit -m
# gcam → git commit -a -m
# gcad → git commit -a --amend
# update → yay -Syu
# grep → grep --color=auto
# cd → zd (custom function, overrides built-in)
# decompress → tar -xzf
#
#
# Functions
#
# n → Open nvim (nvim . if no args, else nvim <file>)
# open → Opens a file/URL with xdg-open in background
# zd → Smarter cd (uses z if not directory, prints folder icon)
# wdev → Create/attach tmux dev session with windows (nvim, pnpm dev, opencode)
# create-vite → Clone vite template repo, reset git, install deps, open wdev
# compress → tar -czf a folder into .tar.gz
# iso2sd → Write ISO image to USB with dd
# format-drive → Format drive as ext4 with GPT, warning prompt
# transcode-video-1080p → ffmpeg convert to H.264 1080p
# transcode-video-4K → ffmpeg convert to H.265 optimized 4K
# img2jpg → convert any image to JPG with quality=95
# img2jpg-small → convert & resize to max 1080px, quality=95
# img2png → convert to optimized PNG with compression


# -----------------------------
# Powerlevel10k Instant Prompt
# -----------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------------------
# Environment Variables
# -----------------------------
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="$EDITOR"
export SYSTEMD_EDITOR="nvim"
export BAT_THEME="ansi"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# Spicetify
export PATH="$PATH:/home/chandrayan0417/.spicetify"

# -----------------------------
# Oh My Zsh & Theme
# -----------------------------
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
  archlinux
  command-not-found
  z
  sudo
  fzf
  fzf-tab
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# Keybindings
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^p' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# -----------------------------
# Aliases
# -----------------------------

alias c='clear'
# File system
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias g='git'
alias d='docker'
alias r='rails'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias update="yay -Syu"
alias grep="grep --color=auto"


# -----------------------------
# Completion & History
# -----------------------------
autoload -Uz compinit
zmodload zsh/complist
compinit

# FZF completion tweaks
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*' fzf-preview 'ls --color=always $realpath'


# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt HIST_VERIFY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY


# -----------------------------
# Functions
# -----------------------------
n() { [[ $# -eq 0 ]] && nvim . || nvim "$@"; }

open() { xdg-open "$@" >/dev/null 2>&1 & }

zd() {
  if [ $# -eq 0 ]; then
    builtin cd ~
  elif [ -d "$1" ]; then
    builtin cd "$1"
  else
    z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}
alias cd="zd"   # safer than aliasing over cd


wdev() {
  SESSION=$(basename "$PWD" | tr . _)
  PROJECT_DIR="$PWD"

  if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Tmux session '$SESSION' already exists."
    read "confirm?Do you want to kill and recreate it? (y/N): "
    case "$confirm" in
      [yY]*) tmux kill-session -t "$SESSION" ;;
      *) echo "Attaching to existing session..."; tmux attach -t "$SESSION"; return ;;
    esac
  fi

  tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR" || { echo "Failed to create tmux session"; return 1; }
  tmux rename-window -t "$SESSION:0" 'nvim'
  tmux send-keys -t "$SESSION:0" 'nvim .' C-m
  tmux new-window -t "$SESSION:1" -n 'server' -c "$PROJECT_DIR" || { echo "Failed to create server window"; return 1; }
  tmux send-keys -t "$SESSION:1" 'pnpm dev' C-m
  tmux split-window -h -t "$SESSION:1" -c "$PROJECT_DIR"

  # Open project with error detection
  (pnpm install) || echo "Warning: 'pnpm install' failed or incomplete."

  # Attach to session
  tmux select-window -t "$SESSION:0"
  tmux attach -t "$SESSION"
}


tmkill() {
  if [[ "$1" == "all" ]]; then
    tmux kill-server
    echo "All tmux sessions killed."
  elif [[ -n "$1" ]]; then
    tmux kill-session -t "$1" && echo "Killed session: $1"
  else
    echo "Usage: tmkill <session_name|all>"
    tmux ls
  fi
}



create-vite() {
  if [ -z "$1" ]; then
    echo "Please provide a project name"
    return 1
  fi
  PROJECT_NAME=$1
  GITHUB_REPO="git@github.com:chandrayan0417/vite-template.git"

  git clone "$GITHUB_REPO" "$PROJECT_NAME" || { echo "Git clone failed"; return 1; }
  cd "$PROJECT_NAME" || { echo "Failed to navigate into project"; return 1; }
  rm -rf .git
  git init -b main || { echo "Git init failed"; return 1; }
  git add . || { echo "Git add failed"; return 1; }
  git commit -m "Initial commit from vite-template" || { echo "Git commit failed"; return 1; }
  pnpm install || { echo "pnpm install failed"; return 1; }
  wdev
}


compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"


iso2sd() {
  if [ $# -ne 2 ]; then
    echo "Usage: iso2sd <input_file> <output_device>"
    lsblk -d -o NAME | grep -E '^sd[a-z]' | awk '{print "/dev/"$1}'
  else
    echo "You are about to write $1 to $2. Are you sure? This will erase the drive! (y/N)"
    read -r confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      sudo dd bs=4M status=progress oflag=sync if="$1" of="$2" || echo "Error during dd operation."
      sudo eject "$2"
    else
      echo "Operation cancelled."
    fi
  fi
}


format-drive() {
  if [ $# -ne 2 ]; then
    echo "Usage: format-drive <device> <name>"
    lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
  else
    echo "WARNING: This will erase $1 and label it '$2'."
    read -rp "Are you sure? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      sudo wipefs -a "$1"
      sudo dd if=/dev/zero of="$1" bs=1M count=100 status=progress
      sudo parted -s "$1" mklabel gpt
      sudo parted -s "$1" mkpart primary ext4 1MiB 100%
      sudo mkfs.ext4 -L "$2" "$([[ $1 == *"nvme"* ]] && echo "${1}p1" || echo "${1}1")"
      echo "Drive $1 formatted as '$2'."
    fi
  fi
}



pass-otp-insert() {
  if [[ -z "$1" ]]; then
    echo "Usage: pass-otp-insert <pass-entry>"
    return 1
  fi

  secret=$(wl-paste | zbarimg -q --raw - 2>/dev/null)
  if [[ -z "$secret" ]]; then
    echo "No QR code detected in clipboard."
    return 1
  fi

  pass otp insert "$1" <<< "$secret" || { echo "Failed to insert OTP"; return 1; }
  echo "OTP secret added to pass entry: $1"
}



# Media helpers
transcode-video-1080p() { ffmpeg -i "$1" -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy "${1%.*}-1080p.mp4"; }
transcode-video-4K() { ffmpeg -i "$1" -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k "${1%.*}-optimized.mp4"; }
img2jpg() { magick "$1" -quality 95 -strip "${1%.*}.jpg"; }
img2jpg-small() { magick "$1" -resize 1080x\> -quality 95 -strip "${1%.*}.jpg"; }
img2png() { magick "$1" -strip -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all "${1%.*}.png"; }


# Shell integrations
eval "$(zoxide init --cmd cd zsh)"
