#!/bin/bash
#  ╔═══════════════════════════════════════════════════════════════╗
#  ║  Quant BSPWM - Installation Script                           ║
#  ║  Arch Linux / Arch-based distributions                       ║
#  ║  github.com/NuRichter/quant-bspwm                            ║
#  ╚═══════════════════════════════════════════════════════════════╝

set -euo pipefail

# ── Constants ─────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
PINK='\033[38;5;218m'
NC='\033[0m'
BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.quant-backup/$(date '+%Y%m%d_%H%M%S')"
LOG_FILE="/tmp/quant-install-$(date '+%Y%m%d_%H%M%S').log"

# ── Helper Functions ──────────────────────────────────────────────

banner() {
    echo -e "${PINK}"
    cat << 'EOF'

     ██████╗ ██╗   ██╗ █████╗ ███╗   ██╗████████╗
    ██╔═══██╗██║   ██║██╔══██╗████╗  ██║╚══██╔══╝
    ██║   ██║██║   ██║███████║██╔██╗ ██║   ██║
    ██║▄▄ ██║██║   ██║██╔══██║██║╚██╗██║   ██║
    ╚██████╔╝╚██████╔╝██║  ██║██║ ╚████║   ██║
     ╚══▀▀═╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝
        B S P W M    D O T F I L E S

EOF
    echo -e "${NC}"
}

log() {
    echo -e "${GREEN}[+]${NC} $1"
    echo "[$(date '+%H:%M:%S')] $1" >> "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1"
    echo "[$(date '+%H:%M:%S')] WARN: $1" >> "$LOG_FILE"
}

error() {
    echo -e "${RED}[x]${NC} $1"
    echo "[$(date '+%H:%M:%S')] ERROR: $1" >> "$LOG_FILE"
}

info() {
    echo -e "${CYAN}[i]${NC} $1"
}

ask() {
    echo -en "${MAGENTA}[?]${NC} $1 [Y/n]: "
    read -r response
    [[ -z "$response" || "$response" =~ ^[Yy]$ ]]
}

# ── Checks ────────────────────────────────────────────────────────

check_arch() {
    if ! command -v pacman &>/dev/null; then
        error "This script requires Arch Linux or an Arch-based distribution."
        error "pacman package manager not found."
        exit 1
    fi
}

check_root() {
    if [[ $EUID -eq 0 ]]; then
        error "Do not run this script as root. It will use sudo when needed."
        exit 1
    fi
}

check_internet() {
    if ! ping -c 1 archlinux.org &>/dev/null; then
        error "No internet connection detected."
        exit 1
    fi
}

# ── AUR Helper ────────────────────────────────────────────────────

install_aur_helper() {
    if command -v yay &>/dev/null; then
        AUR="yay"
    elif command -v paru &>/dev/null; then
        AUR="paru"
    else
        log "Installing yay (AUR helper)..."
        sudo pacman -S --needed --noconfirm git base-devel
        local tmpdir
        tmpdir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
        (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
        rm -rf "$tmpdir"
        AUR="yay"
    fi
    log "AUR helper: $AUR"
}

# ── Package Installation ─────────────────────────────────────────

install_packages() {
    log "Installing core packages..."

    # Core WM
    local core_pkgs=(
        bspwm sxhkd
        polybar
        picom
        rofi
        dunst
        feh
        xorg-server xorg-xinit xorg-xsetroot xorg-xrandr xorg-xdpyinfo
        xdotool xclip xsel xautolock
    )

    # Terminal
    local term_pkgs=(
        kitty alacritty
        starship
        zsh
        tmux
    )

    # File management
    local file_pkgs=(
        thunar thunar-archive-plugin thunar-volman
        file-roller unzip p7zip
        yazi ffmpegthumbnailer unar
    )

    # Media
    local media_pkgs=(
        mpv feh sxiv
        pavucontrol pamixer playerctl
        brightnessctl
        maim
    )

    # Fonts (trilingual support)
    local font_pkgs=(
        ttf-jetbrains-mono-nerd
        noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
        ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
        otf-font-awesome
    )

    # Input method (Japanese/Indonesian)
    local ime_pkgs=(
        fcitx5 fcitx5-mozc fcitx5-gtk fcitx5-qt fcitx5-configtool
    )

    # Theming
    local theme_pkgs=(
        lxappearance
        papirus-icon-theme
        kvantum
    )

    # Editor and dev tools
    local editor_pkgs=(
        neovim
        lazygit
        git-delta
        bat
        eza
        fd
        ripgrep
        fzf
        zoxide
        dust
        duf
        procs
    )

    # Utilities
    local util_pkgs=(
        polkit-gnome
        network-manager-applet
        redshift
        clipmenu
        btop neofetch
        zathura zathura-pdf-mupdf
        imagemagick
        jq bc
        bluez bluez-utils
    )

    # System
    local sys_pkgs=(
        pipewire pipewire-alsa pipewire-pulse wireplumber
        networkmanager
        git curl wget
    )

    sudo pacman -S --needed --noconfirm \
        "${core_pkgs[@]}" \
        "${term_pkgs[@]}" \
        "${file_pkgs[@]}" \
        "${media_pkgs[@]}" \
        "${font_pkgs[@]}" \
        "${ime_pkgs[@]}" \
        "${theme_pkgs[@]}" \
        "${editor_pkgs[@]}" \
        "${util_pkgs[@]}" \
        "${sys_pkgs[@]}" 2>&1 | tee -a "$LOG_FILE"

    log "Core packages installed."
}

install_aur_packages() {
    if ask "Install AUR packages? (i3lock-color, cava, catppuccin themes)"; then
        log "Installing AUR packages..."

        local aur_pkgs=(
            i3lock-color
            cava
            catppuccin-gtk-theme-mocha
            catppuccin-cursors-mocha
            rofi-emoji
            rofi-calc
            clipmenu
            xcolor
        )

        $AUR -S --needed --noconfirm "${aur_pkgs[@]}" 2>&1 | tee -a "$LOG_FILE"
        log "AUR packages installed."
    fi
}

# ── Backup ────────────────────────────────────────────────────────

backup_existing() {
    log "Backing up existing configuration..."
    mkdir -p "$BACKUP_DIR"

    local configs=(
        "$HOME/.config/bspwm"
        "$HOME/.config/sxhkd"
        "$HOME/.config/polybar"
        "$HOME/.config/picom"
        "$HOME/.config/rofi"
        "$HOME/.config/kitty"
        "$HOME/.config/alacritty"
        "$HOME/.config/dunst"
        "$HOME/.config/neofetch"
        "$HOME/.config/starship"
        "$HOME/.config/zathura"
        "$HOME/.config/btop"
        "$HOME/.config/cava"
        "$HOME/.config/gtk-3.0"
        "$HOME/.config/gtk-4.0"
        "$HOME/.config/fcitx5"
        "$HOME/.config/nvim"
        "$HOME/.config/tmux"
        "$HOME/.config/yazi"
        "$HOME/.config/mpv"
        "$HOME/.config/lazygit"
        "$HOME/.config/bat"
        "$HOME/.config/fontconfig"
        "$HOME/.config/git"
        "$HOME/.config/environment.d"
        "$HOME/.Xresources"
        "$HOME/.xinitrc"
        "$HOME/.xprofile"
        "$HOME/.zshrc"
        "$HOME/.editorconfig"
    )

    for item in "${configs[@]}"; do
        if [[ -e "$item" ]]; then
            cp -r "$item" "$BACKUP_DIR/" 2>/dev/null || true
            info "Backed up: $item"
        fi
    done

    log "Backup saved to: $BACKUP_DIR"
}

# ── Deploy ────────────────────────────────────────────────────────

deploy_configs() {
    log "Deploying Quant BSPWM configuration..."

    # Config directories
    local config_dirs=(
        bspwm sxhkd polybar picom rofi kitty alacritty
        dunst neofetch starship zathura btop cava
        gtk-3.0 gtk-4.0 fcitx5
        nvim tmux yazi mpv lazygit bat fontconfig
        git environment.d
    )

    for dir in "${config_dirs[@]}"; do
        if [[ -d "$SCRIPT_DIR/.config/$dir" ]]; then
            mkdir -p "$HOME/.config/$dir"
            cp -rf "$SCRIPT_DIR/.config/$dir/"* "$HOME/.config/$dir/" 2>/dev/null || true
            info "Deployed: .config/$dir"
        fi
    done

    # Rofi subdirs
    mkdir -p "$HOME/.config/rofi/themes"
    mkdir -p "$HOME/.config/rofi/scripts"

    # Scripts
    if [[ -d "$SCRIPT_DIR/scripts" ]]; then
        mkdir -p "$HOME/scripts"
        cp -rf "$SCRIPT_DIR/scripts/"* "$HOME/scripts/"
        chmod +x "$HOME/scripts/"*.sh 2>/dev/null || true
        info "Deployed: scripts/"
    fi

    # Wallpapers
    if [[ -d "$SCRIPT_DIR/wallpapers" ]]; then
        mkdir -p "$HOME/wallpapers"
        cp -rf "$SCRIPT_DIR/wallpapers/"* "$HOME/wallpapers/" 2>/dev/null || true
        info "Deployed: wallpapers/"
    fi

    # Root-level dotfiles
    for dotfile in .Xresources .xinitrc .xprofile .zshrc .editorconfig; do
        if [[ -f "$SCRIPT_DIR/$dotfile" ]]; then
            cp -f "$SCRIPT_DIR/$dotfile" "$HOME/$dotfile"
            info "Deployed: $dotfile"
        fi
    done

    # Mimeapps
    if [[ -f "$SCRIPT_DIR/.config/mimeapps.list" ]]; then
        cp -f "$SCRIPT_DIR/.config/mimeapps.list" "$HOME/.config/mimeapps.list"
        info "Deployed: mimeapps.list"
    fi

    # User directories
    if [[ -f "$SCRIPT_DIR/.config/user-dirs.dirs" ]]; then
        cp -f "$SCRIPT_DIR/.config/user-dirs.dirs" "$HOME/.config/user-dirs.dirs"
        info "Deployed: user-dirs.dirs"
    fi

    # Set permissions
    chmod +x "$HOME/.config/bspwm/bspwmrc"
    chmod +x "$HOME/.config/bspwm/external-rules.sh" 2>/dev/null || true
    chmod +x "$HOME/.config/polybar/launch.sh"
    chmod +x "$HOME/.xinitrc"

    log "Configuration deployed successfully."
}

# ── Post-install ──────────────────────────────────────────────────

post_install() {
    log "Running post-installation tasks..."

    # Load Xresources
    if [[ -f "$HOME/.Xresources" ]]; then
        xrdb -merge "$HOME/.Xresources" 2>/dev/null || true
    fi

    # Set default shell to zsh
    if ask "Set default shell to zsh?"; then
        chsh -s "$(which zsh)" 2>/dev/null || warn "Failed to set shell. Run: chsh -s \$(which zsh)"
    fi

    # Starship init
    if ! grep -q "starship init" "$HOME/.zshrc" 2>/dev/null; then
        {
            echo ""
            echo "# Quant BSPWM - Starship prompt"
            echo 'export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"'
            echo 'eval "$(starship init zsh)"'
        } >> "$HOME/.zshrc" 2>/dev/null || true
    fi

    if ! grep -q "starship init" "$HOME/.bashrc" 2>/dev/null; then
        {
            echo ""
            echo "# Quant BSPWM - Starship prompt"
            echo 'export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"'
            echo 'eval "$(starship init bash)"'
        } >> "$HOME/.bashrc" 2>/dev/null || true
    fi

    # fcitx5 environment variables
    local profile_file="$HOME/.xprofile"
    if [[ ! -f "$profile_file" ]] || ! grep -q "GTK_IM_MODULE" "$profile_file"; then
        {
            echo ""
            echo "# Quant BSPWM - Input Method (fcitx5)"
            echo "export GTK_IM_MODULE=fcitx"
            echo "export QT_IM_MODULE=fcitx"
            echo "export XMODIFIERS=@im=fcitx"
            echo "export SDL_IM_MODULE=fcitx"
            echo "export GLFW_IM_MODULE=ibus"
        } >> "$profile_file"
    fi

    # Enable services
    sudo systemctl enable NetworkManager 2>/dev/null || true
    sudo systemctl enable bluetooth 2>/dev/null || true

    # Font cache
    log "Rebuilding font cache..."
    fc-cache -fv > /dev/null 2>&1

    log "Post-installation complete."
}

# ── Uninstall ─────────────────────────────────────────────────────

uninstall() {
    warn "This will remove all Quant BSPWM configurations."
    if ! ask "Are you sure?"; then
        info "Uninstall cancelled."
        exit 0
    fi

    log "Restoring latest backup..."
    local latest_backup
    latest_backup=$(ls -td "$HOME/.quant-backup/"* 2>/dev/null | head -n1)

    if [[ -n "$latest_backup" && -d "$latest_backup" ]]; then
        cp -rf "$latest_backup/"* "$HOME/" 2>/dev/null || true
        log "Backup restored from: $latest_backup"
    else
        warn "No backup found. Removing configs without restore."
    fi

    log "Quant BSPWM uninstalled."
}

# ── Main ──────────────────────────────────────────────────────────

main() {
    banner

    case "${1:-install}" in
        install)
            check_arch
            check_root
            check_internet

            info "Installation log: $LOG_FILE"
            echo ""

            if ask "Install Quant BSPWM dotfiles?"; then
                install_aur_helper
                install_packages
                install_aur_packages
                backup_existing
                deploy_configs
                post_install

                echo ""
                echo -e "${PINK}${BOLD}"
                echo "  Installation complete!"
                echo ""
                echo -e "  ${NC}${CYAN}Next steps:${NC}"
                echo "    1. Log out and select BSPWM in your display manager"
                echo "       or run: startx"
                echo "    2. Press super+d to open the app launcher"
                echo "    3. Press super+Return for terminal"
                echo "    4. Press super+i to toggle input method (EN/JP)"
                echo ""
                echo -e "  ${CYAN}Backup location:${NC} $BACKUP_DIR"
                echo -e "  ${CYAN}Log file:${NC} $LOG_FILE"
                echo ""
            fi
            ;;
        uninstall)
            uninstall
            ;;
        deploy)
            backup_existing
            deploy_configs
            post_install
            ;;
        *)
            echo "Usage: $0 {install|uninstall|deploy}"
            echo ""
            echo "  install    Full installation (packages + configs)"
            echo "  deploy     Deploy configs only (no package install)"
            echo "  uninstall  Remove configs and restore backup"
            exit 1
            ;;
    esac
}

main "$@"
