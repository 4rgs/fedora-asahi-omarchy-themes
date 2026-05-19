#!/bin/bash
set -e

# ─── Omarchy-style setup for Fedora + Sway ───────────────────────────────────
# Adapts the Omarchy (Arch/Hyprland) experience to Fedora Asahi with Sway.
# Run this once after a fresh install. Idempotent: safe to re-run.

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[+]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
err()   { echo -e "${RED}[x]${NC} $1"; }

# ─── System packages (dnf) ──────────────────────────────────────────────────
info "Installing system packages..."

# Remove swaylock if installed (swaylock-effects replaces it)
if rpm -q swaylock &>/dev/null 2>&1; then
    sudo dnf remove -y swaylock
fi

PACKAGES=(
    git gh
    zsh zoxide tmux
    thunar thunar-archive-plugin thunar-volman
    blueman mako fuzzel
    swaylock-effects swayidle swaybg
    foot waybar grim slurp wmenu brightnessctl
    imv mpv chromium
    flatpak xfce-polkit
    network-manager-applet
    cascadia-code-nf-fonts fontawesome-6-brands-fonts
    gnome-keyring pavucontrol firefox
    power-profiles-daemon
    wireplumber playerctl wl-clipboard jq
    ripgrep fd-find bat eza
    greetd gtkgreet greetd-selinux
)
MISSING=()
for pkg in "${PACKAGES[@]}"; do
    rpm -q "$pkg" &>/dev/null || MISSING+=("$pkg")
done
if [ ${#MISSING[@]} -gt 0 ]; then
    sudo dnf install -y "${MISSING[@]}" || err "Some packages failed to install"
else
    info "All system packages already installed."
fi

# ─── Development tools (dnf) ────────────────────────────────────────────────
info "Installing development tools..."
DEV_PACKAGES=(
    gcc gcc-c++ make cmake
    openssl-devel readline-devel zlib-devel
    docker docker-compose
    nodejs npm
    python3-pip
)
DEV_MISSING=()
for pkg in "${DEV_PACKAGES[@]}"; do
    rpm -q "$pkg" &>/dev/null || DEV_MISSING+=("$pkg")
done
if [ ${#DEV_MISSING[@]} -gt 0 ]; then
    sudo dnf install -y "${DEV_MISSING[@]}" || err "Some dev packages failed to install"
else
    info "All dev packages already installed."
fi

# ─── Flatpak apps ────────────────────────────────────────────────────────────
info "Installing Flatpak apps..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
FLATPAK_APPS=(
    com.spotify.Client
    org.libreoffice.LibreOffice
    org.onlyoffice.desktopeditors
    org.audacityteam.Audacity
    com.obsproject.Studio
    org.filezillaproject.Filezilla
    org.gimp.GIMP
)
for app in "${FLATPAK_APPS[@]}"; do
    flatpak install -y flathub "$app" 2>/dev/null || true
done

# ─── Starship prompt ─────────────────────────────────────────────────────────
info "Installing Starship prompt..."
if ! command -v starship &>/dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# ─── Oh My Zsh ───────────────────────────────────────────────────────────────
info "Setting up Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null || true
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
install_zsh_plugin() {
    local repo="$1" dest="$2"
    if [ ! -d "$dest" ]; then
        git clone --depth=1 "https://github.com/$repo.git" "$dest"
    fi
}
install_zsh_plugin "zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
install_zsh_plugin "zsh-users/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
install_zsh_plugin "ajeetdsouza/zoxide" "$ZSH_CUSTOM/plugins/zoxide"

# ─── Neovim + LazyVim ───────────────────────────────────────────────────────
info "Setting up Neovim + LazyVim..."
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim" || true
    rm -rf "$HOME/.config/nvim/.git" 2>/dev/null || true
fi

# ─── Docker (post-install) ──────────────────────────────────────────────────
info "Configuring Docker..."
sudo systemctl enable --now docker 2>/dev/null || true
sudo groupadd -f docker
sudo usermod -aG docker "$USER" 2>/dev/null || true

# ─── Sway config ────────────────────────────────────────────────────────────
info "Writing Sway config..."
mkdir -p "$HOME/.config/sway"
cat > "$HOME/.config/sway/config" << 'SWAYEOF'
# Sway config — Omarchy-style for Fedora Asahi

### Variables
set $mod Mod4
set $left h
set $down j
set $up k
set $right l
set $term kitty
set $menu fuzzel
set $lock swaylock --effect-blur 7x5 --clock --indicator-idle-visible
set $screenshot grim -g "$(slurp)"
set $wallpaper $HOME/.config/sway/wallpaper.sh

### Wayland environment
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

### Autostart
exec $HOME/.local/bin/omarchy-restore-theme
exec waybar
exec mako
exec $wallpaper
exec /usr/libexec/xfce-polkit
exec nm-applet --indicator
exec blueman-applet
exec gnome-keyring-daemon --start --components=secrets,pkcs11,ssh

### Idle
exec swayidle -w \
    timeout 300 "$lock" \
    timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
    before-sleep "$lock"

### Input
input type:touchpad {
    tap enabled
    natural_scroll enabled
    middle_emulation enabled
}

input type:keyboard {
    xkb_layout "latam"
    xkb_options "ctrl:nocaps"
}

### Output
output * bg #2e2e2e solid_color

### Gaps
gaps inner 4
gaps outer 2
smart_gaps on
smart_borders on

### Window rules
for_window [window_role="pop-up"] floating enable
for_window [window_role="dialog"] floating enable
for_window [window_type="dialog"] floating enable
for_window [window_role="task_dialog"] floating enable
for_window [app_id="pavucontrol"] floating enable
for_window [app_id="blueman-manager"] floating enable
for_window [app_id="nm-connection-editor"] floating enable
for_window [app_id="org.gnome.Calculator"] floating enable
for_window [app_id="org.gnome.Nautilus"] floating enable
for_window [app_id="file-roller"] floating enable
for_window [app_id="TUI.float"] floating enable, move position center
no_focus [window_type="dialog"]
no_focus [app_id="nm-connection-editor"]

### Default border
default_border pixel 1
default_floating_border pixel 1

### Key bindings
bindsym $mod+Return exec $term
bindsym $mod+Shift+q kill
bindsym $mod+d exec $menu
bindsym $mod+Shift+d exec wmenu-run

bindsym Print exec grim "$HOME/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
bindsym $mod+Print exec $screenshot
bindsym $mod+Shift+Print exec grim -g "$(slurp -d)" -

bindsym $mod+Shift+l exec $lock

bindsym $mod+Shift+f exec thunar
bindsym $mod+Shift+b exec chromium-browser
bindsym $mod+Shift+m exec pavucontrol
bindsym $mod+Shift+w exec $wallpaper --once
bindsym $mod+Shift+n exec $HOME/.local/bin/omarchy-toggle-nightlight
bindsym $mod+Shift+u exec $HOME/.local/bin/omarchy-update
bindsym $mod+Shift+r exec $HOME/.local/bin/omarchy-restart-waybar
bindsym $mod+Shift+t exec $term -e ranger
bindsym $mod+Shift+v exec flatpak run com.visualstudio.code
bindsym $mod+Shift+z exec $HOME/.local/bin/omarchy-launch-bluetooth
bindsym $mod+Shift+x exec $HOME/.local/bin/omarchy-launch-powertui
bindsym $mod+Shift+Return exec $term -e tmux new -As main

### Themes
bindsym $mod+o exec $HOME/.local/bin/omarchy-theme-list | head -5
bindsym $mod+Shift+o exec $HOME/.local/bin/omarchy-theme-select
bindsym $mod+Shift+comma exec $HOME/.local/bin/omarchy-theme-bg-next

bindsym $mod+Shift+c reload
bindsym $mod+Shift+e exec $HOME/.local/bin/omarchy-launch-sessiontui

floating_modifier $mod normal

bindsym $mod+$left focus left
bindsym $mod+$down focus down
bindsym $mod+$up focus up
bindsym $mod+$right focus right
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

bindsym $mod+1 workspace number 1
bindsym $mod+2 workspace number 2
bindsym $mod+3 workspace number 3
bindsym $mod+4 workspace number 4
bindsym $mod+5 workspace number 5
bindsym $mod+6 workspace number 6
bindsym $mod+7 workspace number 7
bindsym $mod+8 workspace number 8
bindsym $mod+9 workspace number 9
bindsym $mod+0 workspace number 10
bindsym $mod+Shift+1 move container to workspace number 1
bindsym $mod+Shift+2 move container to workspace number 2
bindsym $mod+Shift+3 move container to workspace number 3
bindsym $mod+Shift+4 move container to workspace number 4
bindsym $mod+Shift+5 move container to workspace number 5
bindsym $mod+Shift+6 move container to workspace number 6
bindsym $mod+Shift+7 move container to workspace number 7
bindsym $mod+Shift+8 move container to workspace number 8
bindsym $mod+Shift+9 move container to workspace number 9
bindsym $mod+Shift+0 move container to workspace number 10

bindsym $mod+b splith
bindsym $mod+v splitv
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split
bindsym $mod+f fullscreen
bindsym $mod+Shift+space floating toggle
bindsym $mod+space focus mode_toggle
bindsym $mod+a focus parent

bindsym $mod+Shift+minus move scratchpad
bindsym $mod+minus scratchpad show

mode "resize" {
    bindsym $left resize shrink width 10px
    bindsym $down resize grow height 10px
    bindsym $up resize shrink height 10px
    bindsym $right resize grow width 10px
    bindsym Left resize shrink width 10px
    bindsym Down resize grow height 10px
    bindsym Up resize shrink height 10px
    bindsym Right resize grow width 10px
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

bindsym --locked XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
bindsym --locked XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym --locked XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym --locked XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle
bindsym --locked XF86AudioPlay exec playerctl play-pause
bindsym --locked XF86AudioNext exec playerctl next
bindsym --locked XF86AudioPrev exec playerctl previous
bindsym --locked XF86MonBrightnessDown exec brightnessctl set 5%-
bindsym --locked XF86MonBrightnessUp exec brightnessctl set 5%+

include /etc/sway/config.d/*
SWAYEOF

# ─── Omarchy theme restore script ───────────────────────────────────────────
info "Creating theme restore script..."
cat > "$HOME/.local/bin/omarchy-restore-theme" << 'RESTOREEOF'
#!/bin/bash
# Restore last theme on Sway startup

THEME_NAME=$(cat "$HOME/.config/omarchy/current/theme.name" 2>/dev/null || echo "")

if [ -n "$THEME_NAME" ] && [ -d "$HOME/.config/omarchy/themes/$THEME_NAME" ]; then
    "$HOME/.local/bin/omarchy-theme-set" "$THEME_NAME"
else
    "$HOME/.config/sway/wallpaper.sh" &
fi
RESTOREEOF
chmod +x "$HOME/.local/bin/omarchy-restore-theme"

# ─── Waybar config ─────────────────────────────────────────────────────────
info "Writing Waybar config..."
mkdir -p "$HOME/.config/waybar"
cat > "$HOME/.config/waybar/config.jsonc" << 'WAYBAREOF'
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "margin-top": 2,
    "margin-bottom": 0,
    "spacing": 4,
    "modules-left": ["sway/workspaces", "sway/mode", "sway/scratchpad"],
    "modules-center": ["clock"],
    "modules-right": ["tray", "pulseaudio", "network", "bluetooth", "cpu", "memory", "custom/battery", "clock"],
    "sway/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{icon}",
        "format-icons": {
            "default": " ",
            "focused": " ",
            "urgent": " "
        }
    },
    "sway/mode": {
        "format": "<span style=\"italic\">{}</span>"
    },
    "clock": {
        "format": "{:%H:%M}",
        "tooltip-format": "{:%A, %d %B %Y}"
    },
    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": " {volume}%",
        "format-icons": {
            "default": ["", "", ""]
        },
        "scroll-step": 5,
        "on-click": "pavucontrol"
    },
    "network": {
        "format-wifi": " {essid}",
        "format-ethernet": " ",
        "format-disconnected": " ",
        "tooltip-format": "{ifname} via {gwaddr}",
        "on-click": "nm-connection-editor"
    },
    "bluetooth": {
        "format": " ",
        "format-disabled": "",
        "on-click": "kitty --class=TUI.float -e bluetui",
        "on-click-right": "blueman-manager"
    },
    "cpu": {
        "format": " {}%",
        "interval": 5
    },
    "memory": {
        "format": " {}%",
        "interval": 10
    },
    "custom/battery": {
        "exec": "$HOME/.local/bin/omarchy-battery",
        "return-type": "json",
        "interval": 30,
        "on-click": "$HOME/.local/bin/omarchy-launch-powertui",
        "tooltip": true
    },
    "tray": {
        "spacing": 10
    }
}
WAYBAREOF

cat > "$HOME/.config/waybar/style.css" << 'WAYBARCSS'
* {
    border: none;
    border-radius: 0;
    font-family: "Cascadia Code NF", "Font Awesome 6 Free", monospace;
    font-size: 12px;
    min-height: 0;
}

window#waybar {
    background: rgba(50, 50, 50, 0.9);
    color: #ffffff;
}

#workspaces button {
    padding: 0 6px;
    background: transparent;
    color: #888888;
    border-bottom: 2px solid transparent;
}

#workspaces button.focused {
    color: #ffffff;
    border-bottom: 2px solid #5294e2;
}

#workspaces button.urgent {
    color: #e05252;
}

#mode {
    background: #5294e2;
    padding: 0 8px;
    color: #ffffff;
}

#clock {
    padding: 0 10px;
    color: #ffffff;
}

#pulseaudio {
    padding: 0 8px;
    color: #a0a0a0;
}

#pulseaudio.muted {
    color: #e05252;
}

#network {
    padding: 0 8px;
    color: #a0a0a0;
}

#network.disconnected {
    color: #e05252;
}

#bluetooth {
    padding: 0 8px;
    color: #5294e2;
}

#bluetooth.disabled {
    color: #555555;
}

#cpu {
    padding: 0 8px;
    color: #a0a0a0;
}

#memory {
    padding: 0 8px;
    color: #a0a0a0;
}

#custom-battery {
    padding: 0 8px;
    color: #a0a0a0;
}

#custom-battery.charging {
    color: #8cc665;
}

#custom-battery.warning:not(.charging) {
    color: #e05252;
}

#tray {
    padding: 0 6px;
}
WAYBARCSS

# ─── Mako config ───────────────────────────────────────────────────────────
info "Writing Mako config..."
mkdir -p "$HOME/.config/mako"
cat > "$HOME/.config/mako/config" << 'MAKOEOF'
font=monospace 10
background-color=#323232
text-color=#ffffff
border-color=#5294e2
border-size=2
border-radius=6
default-timeout=5000
max-icon-size=32
sort=-time
MAKOEOF

# ─── Wallpaper script ──────────────────────────────────────────────────────
info "Writing wallpaper script..."
cat > "$HOME/.config/sway/wallpaper.sh" << 'WPEOF'
#!/bin/bash
# Random wallpaper picker for swaybg

WALLPAPER_DIR="${WALLPAPER_DIR:-/usr/share/backgrounds/sway}"

pkill swaybg 2>/dev/null

if [ -n "$1" ] && [ -f "$1" ]; then
    img="$1"
else
    mapfile -t imgs < <(find "$WALLPAPER_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) 2>/dev/null)
    if [ ${#imgs[@]} -eq 0 ]; then
        notify-send -u critical "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi
    img="${imgs[RANDOM % ${#imgs[@]}]}"
fi

swaybg -i "$img" -m fill &>/dev/null &
disown
WPEOF
chmod +x "$HOME/.config/sway/wallpaper.sh"

# ─── greetd (display manager) ──────────────────────────────────────────────
info "Setting up greetd display manager..."
sudo mkdir -p /etc/greetd

sudo tee /etc/greetd/config.toml > /dev/null << 'GREETDEOF'
[terminal]
vt = 1

[default_session]
command = "sway --config /etc/greetd/greetd-sway-config"
user = "greeter"
GREETDEOF

sudo tee /etc/greetd/greetd-sway-config > /dev/null << SWAYEOF
# Minimal Sway config for greetd greeter
set \$bg_path $HOME/.config/omarchy/current/sddm-bg
set \$css_path $HOME/.config/omarchy/current/gtkgreet.css

exec_always swaybg -i \$bg_path -m fill
exec "gtkgreet -l -s \$css_path; swaymsg exit"

input type:keyboard {
    xkb_layout "latam"
    xkb_options "ctrl:nocaps"
}

input type:touchpad {
    tap enabled
    natural_scroll enabled
    middle_emulation enabled
}

default_border pixel 1
SWAYEOF

# Ensure greeter can read theme files from user's home
sudo chmod +x "$HOME"
sudo chmod +x "$HOME/.config"
sudo chmod -R +r "$HOME/.config/omarchy/current" 2>/dev/null

# Set up greeter user groups
sudo usermod -a -G video,input greeter 2>/dev/null || true

# Environment for the greeter
sudo mkdir -p /etc/systemd/system/greetd.service.d
sudo tee /etc/systemd/system/greetd.service.d/override.conf > /dev/null << 'SYSTEMDEOF'
[Service]
Environment=GDK_BACKEND=wayland
Environment=PATH=/usr/local/bin:/usr/bin:/bin
SYSTEMDEOF
sudo systemctl daemon-reload

# Disable SDDM if installed, enable greetd
sudo systemctl disable --now sddm 2>/dev/null || true
sudo systemctl enable --now greetd

# ─── Enable system services ──────────────────────────────────────────────────
info "Enabling system services..."
sudo systemctl enable --now power-profiles-daemon 2>/dev/null || true

# ─── Enable user services ───────────────────────────────────────────────────
info "Enabling user services..."
systemctl --user enable --now wireplumber 2>/dev/null || true
systemctl --user enable --now mako 2>/dev/null || true

# ─── Zsh as default shell ──────────────────────────────────────────────────
if command -v zsh &>/dev/null && [ "$SHELL" != "$(which zsh)" ]; then
    warn "Changing default shell to Zsh. You may need to log out and back in."
    sudo chsh -s "$(which zsh)" "$USER"
fi

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
info "Installation complete!"
echo ""
echo "  ${YELLOW}Next steps:${NC}"
echo "  1. Log out and back in (or run 'zsh' to start using Zsh)"
echo "  2. greetd will start automatically — log in with your GTK-themed greeter"
echo "  3. Open nvim to finish LazyVim plugin installation"
echo "  4. Set up 1Password manually if needed"
echo ""
echo "  ${YELLOW}Tips:${NC}"
echo "  - Super+Enter      = foot terminal"
echo "  - Super+d          = fuzzel app launcher (type any app name)"
echo "  - Super+Shift+d    = wmenu-run (alt launcher)"
echo "  - Super+Shift+l    = lock screen"
echo "  - Super+Shift+e    = session menu (logout/reboot/shutdown/switch user)"
echo "  - Super+Shift+w    = cycle wallpaper"
echo "  - Print            = full screenshot"
echo "  - Super+Print      = region screenshot (click & drag)"
