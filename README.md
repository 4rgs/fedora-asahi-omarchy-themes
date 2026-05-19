# Fedora Asahi Omarchy Themes

Configuración estilo Omarchy para Fedora Asahi + Sway. Sistema completo de tematización con 19 temas, gestor de pantalla themado, bloqueo de pantalla, terminal transparente y más.

## Requisitos

- Fedora Asahi (Sway spin)
- Los siguientes paquetes instalados: `sway`, `waybar`, `kitty`, `mako`, `fuzzel`, `swaylock`, `swaybg`, `btop`, `ranger`, `thunar`, `chromium-browser`

## Instalación

```bash
# 1. Clonar
git clone https://github.com/4rgs/fedora-asahi-omarchy-themes.git ~/dotfiles

# 2. Copiar configs
cp -r ~/dotfiles/.config/* ~/.config/
cp -r ~/dotfiles/.local/bin/* ~/.local/bin/
cp ~/dotfiles/.zshrc ~/

# 3. Instalar dependencias opcionales
omarchy-install-all

# 4. Activar SDDM themado (login screen)
sudo omarchy-enable-sddm-theme

# 5. Aplicar tema
omarchy-theme-set gruvbox

# 6. Recargar Sway
swaymsg reload
```

## Atajos de teclado

| Tecla | Acción |
|---|---|
| `$mod+Return` | Terminal (kitty) |
| `$mod+D` | Lanzador (fuzzel) |
| `$mod+Shift+Q` | Cerrar ventana |
| `$mod+O` | Mostrar tema activo |
| `$mod+Shift+O` | Selector de temas |
| `$mod+Shift+,` | Siguiente fondo |
| `$mod+Shift+W` | Siguiente wallpaper |
| `$mod+Shift+F` | Thunar (explorador) |
| `$mod+Shift+T` | Ranger (terminal) |
| `$mod+Shift+B` | Chromium |
| `$mod+Shift+V` | VS Code |
| `$mod+Shift+Z` | Bluetooth TUI (bluetui) |
| `$mod+Shift+N` | Alternar luz nocturna |
| `$mod+Shift+U` | Actualizar sistema |
| `$mod+Shift+R` | Reiniciar waybar |
| `$mod+Shift+L` | Bloquear pantalla |
| `$mod+Shift+C` | Recargar Sway |
| `Print` | Captura de pantalla |
| `$mod+Shift+Print` | Captura de área |

## Temas disponibles

```
catppuccin        catppuccin-latte  ethereal          everforest
flexoki-light     gruvbox           hackerman         kanagawa
lumon             matte-black       miasma            nord
osaka-jade        retro-82          ristretto         rose-pine
tokyo-night       vantablack        white
```

## Componentes tematizados

| Componente | Archivo generado |
|---|---|
| Waybar (barra) | `~/.config/waybar/style.css` |
| Kitty (terminal) | `~/.config/kitty/kitty.conf` |
| Mako (notificaciones) | `~/.config/mako/config` |
| Fuzzel (lanzador) | `~/.config/fuzzel/fuzzel.ini` |
| Swaylock (bloqueo) | `~/.config/swaylock/config` |
| GTK3/GTK4 (apps) | `~/.config/gtk-3.0/gtk.css` |
| Btop (monitor) | `~/.config/btop/themes/<tema>.theme` |
| Neovim (editor) | `~/.config/nvim/lua/plugins/theme.lua` |
| SDDM (login) | `/usr/share/sddm/themes/omarchy/` |
| Chromium (navegador) | `chromium.theme` (4 temas) |
| VS Code | `~/.config/Code/User/settings.json` |
| Wallpaper | `~/.config/omarchy/backgrounds/<tema>/` |

## Comandos

| Comando | Función |
|---|---|
| `omarchy-theme-set <tema>` | Aplicar tema |
| `omarchy-theme-select` | Selector interactivo (vía fuzzel) |
| `omarchy-theme-bg-next` | Siguiente fondo del tema |
| `omarchy-restore-theme` | Restaurar tema al inicio |
| `omarchy-restart-waybar` | Reiniciar waybar |
| `omarchy-toggle-nightlight` | Alternar luz nocturna |
| `omarchy-update` | Actualizar sistema |
| `omarchy-launch-bluetooth` | Bluetooth TUI |
| `omarchy-enable-sddm-theme` | Activar SDDM themado (sudo) |
| `omarchy-update-sddm-theme` | Sincronizar SDDM tras cambio (sudo) |
| `omarchy-install-all` | Instalar Chromium + VS Code + bluetui |

## Personalización

### Opacidad del terminal

Editar `~/.config/omarchy/templates/kitty.conf.tpl`:
```
background_opacity 0.5   ← cambiar valor
```

### Intervalo de rotación de fondos

Editar `~/.config/sway/wallpaper.sh`:
```
INTERVAL="${INTERVAL:-1800}"   ← cambiar segundos
```

### Gaps de ventanas

Editar `~/.config/sway/config`:
```
gaps inner 20
gaps outer 15
```

## Changelog

### v1.0.0 (2026-05-18)

- Sistema de temas con 19 temas de Omarchy
- Theming completo de: Waybar, Kitty, Mako, Fuzzel, Swaylock, GTK3/4, Btop, Neovim
- SDDM login screen themado con colores del tema activo
- Kitty terminal con 50% de opacidad y bordes minimalistas
- Rotación automática de fondos de pantalla desde ~/Pictures
- Selector interactivo de temas vía fuzzel ($mod+Shift+O)
- Gestor Bluetooth TUI (bluetui) integrado
- Chromium browser + VS Code instalación y theming
- Scripts de instalación (omarchy-install-*)
- Corrección de display manager (graphical.target)
- Gaps de ventanas (inner 20, outer 15)
- Sombra y transparencia en waybar
- Temas guardados en repositorio GitHub
