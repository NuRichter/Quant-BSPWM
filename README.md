<p align="center">
  <img src="https://img.shields.io/badge/WM-BSPWM-f5c2e7?style=for-the-badge&logo=linux&logoColor=white" />
  <img src="https://img.shields.io/badge/OS-Arch_Linux-89b4fa?style=for-the-badge&logo=archlinux&logoColor=white" />
  <img src="https://img.shields.io/badge/Shell-Zsh-c4a7e7?style=for-the-badge&logo=gnubash&logoColor=white" />
  <img src="https://img.shields.io/badge/Language-EN_|_ID_|_JP-fab387?style=for-the-badge" />
</p>

<h1 align="center">Quant BSPWM</h1>

<p align="center">
  <em>A precision-crafted tiling window manager environment</em><br/>
  <em>for Arch Linux, engineered for trilingual workflows.</em>
</p>

---

## Overview

Quant BSPWM is a complete desktop environment configuration built on top of
BSPWM for Arch Linux. It provides a cohesive visual experience with a custom
dark-pastel colorscheme, multi-monitor support, and native trilingual input
(English, Indonesian, Japanese) via fcitx5 + Mozc.

Every component is configured from scratch with a unified "Quant" palette
that prioritizes readability during extended sessions while maintaining
visual elegance.

## Components

| Component       | Software           | Purpose                         |
|-----------------|--------------------|---------------------------------|
| Window Manager  | bspwm              | Tiling WM with kanji workspaces |
| Keybindings     | sxhkd              | Hotkey daemon                   |
| Panel           | Polybar             | Status bar with custom modules  |
| Compositor      | Picom               | Shadows, blur, rounded corners  |
| Launcher        | Rofi                | App launcher, window switcher   |
| Terminal        | Kitty + Alacritty   | Primary + fallback terminal     |
| Notifications   | Dunst               | Notification daemon             |
| Prompt          | Starship            | Cross-shell prompt              |
| PDF Viewer      | Zathura             | Vim-keybind PDF reader          |
| Lock Screen     | i3lock-color        | Customized lock screen          |
| Input Method    | fcitx5 + Mozc       | EN / ID / JP input              |
| File Manager    | Thunar              | GTK file manager                |
| System Monitor  | btop                | Resource monitor                |
| Audio Visualizer| cava                | Terminal audio visualizer       |
| Wallpaper       | feh                 | Wallpaper setter                |
| GTK Theme       | Catppuccin Mocha    | Application theming             |
| Icons           | Papirus Dark        | Icon theme                      |
| Cursor          | Catppuccin Cursors  | Cursor theme                    |
| Fonts           | JetBrainsMono Nerd  | Primary monospace font          |
| CJK Fonts       | Noto Sans CJK JP    | Japanese/CJK rendering          |

## Colorscheme

The Quant palette is a custom dark-pastel scheme designed for WCAG AA
readability on dark backgrounds.

| Color       | Hex       | Role                    |
|-------------|-----------|-------------------------|
| Void        | `#0e0c15` | Deepest background      |
| Abyss       | `#16141f` | Primary background      |
| Shadow      | `#1e1c2a` | Active surfaces         |
| Mist        | `#2a2837` | Subtle borders          |
| Whisper     | `#6e6a86` | Disabled text           |
| Snow        | `#e0def4` | Primary text            |
| Sakura      | `#f5c2e7` | Primary accent          |
| Wisteria    | `#c4a7e7` | Secondary accent        |
| Orchid      | `#cba6f7` | Titles                  |
| Azure       | `#89b4fa` | Links, info             |
| Mint        | `#94e2d5` | Success                 |
| Apricot     | `#fab387` | Warnings                |
| Crimson     | `#f38ba8` | Errors                  |
| Honey       | `#f9e2af` | Highlights              |
| Jade        | `#a6e3a1` | Strings                 |

## Keybindings

### Core

| Keys                    | Action                   |
|-------------------------|--------------------------|
| `super + Return`        | Terminal                 |
| `super + d`             | App launcher             |
| `super + q`             | Close window             |
| `super + Tab`           | Window switcher          |
| `super + shift + r`     | Reload bspwm             |
| `super + Escape`        | Reload keybindings       |
| `super + shift + q`     | Power menu               |
| `super + l`             | Lock screen              |

### Navigation

| Keys                    | Action                   |
|-------------------------|--------------------------|
| `super + {h,j,k,l}`    | Focus direction          |
| `super + shift + {h,j,k,l}` | Swap direction      |
| `super + {1-9,0}`      | Focus desktop            |
| `super + shift + {1-9,0}` | Send to desktop       |
| `super + alt + {h,j,k,l}` | Resize window         |
| `super + space`         | Toggle floating          |
| `super + f`             | Toggle fullscreen        |
| `super + m`             | Toggle monocle           |

### Utilities

| Keys                    | Action                   |
|-------------------------|--------------------------|
| `super + e`             | File manager             |
| `super + b`             | Web browser              |
| `super + c`             | Code editor              |
| `super + v`             | Clipboard history        |
| `super + p`             | Color picker             |
| `super + i`             | Toggle input method      |
| `super + w`             | Cycle wallpaper          |
| `super + n`             | Notification history     |
| `super + minus`         | Scratchpad terminal      |
| `Print`                 | Screenshot (full)        |
| `super + Print`         | Screenshot (selection)   |

## Trilingual Support

Quant provides native support for English, Indonesian, and Japanese input:

1. **fcitx5** handles input method switching
2. **Mozc** provides Japanese IME (hiragana, katakana, kanji)
3. Toggle with `super + i`
4. Status displayed in polybar (EN/JP indicator)

### Font Stack

The font configuration ensures proper rendering across all three languages:

- **Latin/Indonesian:** JetBrainsMono Nerd Font
- **Japanese (Kana/Kanji):** Noto Sans CJK JP
- **Emoji:** Noto Color Emoji

CJK characters are explicitly mapped in Kitty via `symbol_map` directives
covering Unicode ranges U+3000-U+9FAF.

## Installation

### Prerequisites

- Arch Linux or Arch-based distribution
- Active internet connection
- Non-root user with sudo access

### Quick Install

```bash
git clone https://github.com/NuRichter/quant-bspwm.git
cd quant-bspwm
chmod +x install.sh
./install.sh install
```

### Deploy Only (skip package installation)

```bash
./install.sh deploy
```

### Uninstall

```bash
./install.sh uninstall
```

The installer automatically backs up existing configurations before
deploying. Backups are stored in `~/.quant-backup/`.

## Post-Install

1. Log out and select **BSPWM** in your display manager, or run `startx`
2. Open `fcitx5-configtool` to verify input methods are configured
3. Place wallpapers in `~/wallpapers/`
4. Adjust DPI in `~/.Xresources` if needed (`Xft.dpi`)

## Hardware Targets

Tested and optimized for:

- **Desktop:** Ryzen 5 9600X + RTX 5060 Ti 16GB + 32GB RAM
- **Laptop:** MSI Vector 16 HX (i7-255HX + RTX 5070 Ti 12GB + 32GB DDR5)

Picom is configured for GLX backend with NVIDIA-specific optimizations.

## Directory Structure

```
quant-bspwm/
  .config/
    bspwm/          Window manager config + rules
    sxhkd/          Keybindings
    polybar/        Status bar config + launcher
    picom/          Compositor settings
    rofi/           Launcher themes (launcher, window, power)
    kitty/          Primary terminal
    alacritty/      Fallback terminal
    dunst/          Notification daemon
    neofetch/       System info display
    starship/       Shell prompt
    zathura/        PDF viewer
    btop/           System monitor theme
    cava/           Audio visualizer
    gtk-3.0/        GTK3 theme settings
    gtk-4.0/        GTK4 theme settings
    fcitx5/         Input method profile
  scripts/          Utility scripts
  wallpapers/       Wallpaper directory
  docs/             Documentation + colorscheme spec
  .Xresources       X11 resources
  .xinitrc           X11 init
  install.sh         Installation script
```

## Credits

- Colorscheme inspired by [Catppuccin](https://github.com/catppuccin/catppuccin) with custom modifications
- Font: [JetBrains Mono](https://www.jetbrains.com/lp/mono/) with Nerd Font patches
- Icons: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)

## License

MIT License. See [LICENSE](LICENSE) for details.

---

<p align="center">
  <em>Crafted by NuRichter Workspace</em>
</p>
