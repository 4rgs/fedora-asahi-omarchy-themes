# Changelog

## 2026-05-18

### Battery & Power Management
- Added `omarchy-battery` — custom waybar battery indicator with Font Awesome icons, health %, cycles, temperature, power draw, and time remaining tooltip
- Added `omarchy-powertui` — interactive power management TUI (bash + fzf) with battery info, power profiles, suspend, shutdown, reboot, and lock screen
- Added `omarchy-launch-powertui` — single-instance launcher (focuses existing TUI if already open)
- Updated `omarchy-launch-bluetooth` — single-instance launcher (shares TUI.float class)
- Waybar battery module replaced with `custom/battery` using JSON output from `omarchy-battery`
- Click on battery in waybar opens powertui TUI

### Sway Configuration
- Added `for_window [app_id="TUI.float"] floating enable, move position center` — all TUIs open as centered floating windows
- Added keybinding `Super+Shift+x` — opens powertui TUI
- Added keybindings for nightlight, update, waybar restart, ranger, vscode, bluetooth, themes, and wallpaper cycling

### Theme Persistence
- Added `omarchy-restore-theme` — restores last applied theme on sway startup
- Added to sway autostart: `exec $HOME/.local/bin/omarchy-restore-theme`
- Theme name persisted in `~/.config/omarchy/current/theme.name`

### Install Script
- Added `power-profiles-daemon` to system packages
- Enabled `power-profiles-daemon` systemd service
- Added `omarchy-restore-theme` script creation to installer
- Updated sway config template with all new keybindings and TUI.float rule
- Updated waybar config template with `custom/battery` module
- Updated waybar CSS template with `#custom-battery` styles

### Power Profiles
- TUI dynamically lists available profiles from `powerprofilesctl list`
- Graceful fallback when `powerprofilesctl` is unavailable

### SDDM Theme Persistence
- Rewrote `omarchy-enable-sddm-theme` — copies theme to `/usr/share/sddm/themes/omarchy/` and `chown`s to user, so `omarchy-theme-set` can update it without sudo
- Updated `omarchy-theme-set` — syncs QML, theme.conf, and background to `/usr/share/sddm/themes/omarchy/` when the user owns it
- SELinux-safe: system theme dir avoids home directory access restrictions
- Added `omarchy-enable-sddm-theme` call to install script
- Switched to gruvbox theme across all apps (kitty, fuzzel, gtk, mako, nvim, swaylock, waybar, SDDM)

### Session Management TUI
- Added `omarchy-sessiontui` — TUI for lock, logout, switch user, suspend, reboot, shutdown
- Added `omarchy-launch-sessiontui` — single-instance launcher (TUI.float class)
- Replaced swaynag exit with session TUI on `Super+Shift+e`

### Display Manager: SDDM → greetd + gtkgreet
- Replaced SDDM with greetd + gtkgreet for better theme persistence
- Created `omarchy-enable-greetd` — sets up greetd with greeter Sway config
- Created `gtkgreet.css.tpl` — themed greeter CSS using omarchy colors
- Updated `omarchy-theme-set` — generates gtkgreet CSS from theme colors
- All paths now dynamic (`$HOME`, `$SUDO_USER`, `$(dirname "$0")`) — no hardcoded `/home/4rgs`
- SDDM configs and theme files deprecated
- Updated install script packages and config templates
