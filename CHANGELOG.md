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
- Updated `omarchy-enable-sddm-theme` — points `ThemeDir` directly to `~/.config/sddm/themes` instead of copying to `/usr/share/`
- SDDM now reads theme changes automatically without needing sudo after the initial setup
- Switched to gruvbox theme across all apps (kitty, fuzzel, gtk, mako, nvim, swaylock, waybar, SDDM)
- Fixed `omarchy-enable-sddm-theme` — hardcoded user path instead of `$HOME` to avoid sudo changing it to `/root`
