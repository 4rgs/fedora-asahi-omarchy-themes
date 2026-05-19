* {
    border: none;
    border-radius: 0;
    font-family: "Cascadia Code NF", "Font Awesome 6 Free", monospace;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: rgba({{ background_rgb }}, 0.9);
    color: {{ foreground }};
    border-bottom: 1px solid rgba({{ accent_rgb }}, 0.3);
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.4);
    transition-property: background-color;
    transition-duration: 0.3s;
}

window#waybar.hidden {
    opacity: 0.2;
}

#custom-apps {
    font-size: 18px;
    padding: 0 12px;
    color: {{ accent }};
}

#workspaces {
    margin: 2px 4px;
}

#workspaces button {
    padding: 0 6px;
    background: transparent;
    color: {{ color8 }};
    border-bottom: 2px solid transparent;
    transition: all 0.2s ease;
}

#workspaces button.focused {
    color: {{ foreground }};
    border-bottom: 2px solid {{ accent }};
}

#workspaces button.urgent {
    color: {{ color1 }};
    border-bottom: 2px solid {{ color1 }};
}

#workspaces button:hover {
    background: rgba({{ accent_rgb }}, 0.15);
    color: {{ foreground }};
}

#mode {
    background: {{ accent }};
    color: {{ background }};
    border-radius: 4px;
    padding: 0 8px;
    margin: 3px 0;
    font-weight: bold;
}

#clock {
    padding: 0 14px;
    color: {{ foreground }};
    font-weight: bold;
    letter-spacing: 1px;
}

#custom-notification {
    padding: 0 8px;
    color: {{ color8 }};
}

#custom-notification.snoozed {
    color: {{ color1 }};
}

#tray {
    padding: 0 6px;
    margin: 2px 0;
}

#pulseaudio {
    padding: 0 8px;
    color: {{ foreground }};
    border-radius: 4px;
    margin: 3px 0;
}

#pulseaudio.muted {
    color: {{ color1 }};
}

#network {
    padding: 0 8px;
    color: {{ foreground }};
    border-radius: 4px;
    margin: 3px 0;
}

#network.disconnected {
    color: {{ color1 }};
}

#network.disabled {
    color: {{ color8 }};
}

#bluetooth {
    padding: 0 8px;
    color: {{ accent }};
    border-radius: 4px;
    margin: 3px 0;
}

#bluetooth.disabled {
    color: {{ color8 }};
}

#cpu {
    padding: 0 8px;
    color: {{ foreground }};
    border-radius: 4px;
    margin: 3px 0;
}

#memory {
    padding: 0 8px;
    color: {{ foreground }};
    border-radius: 4px;
    margin: 3px 0;
}

#custom-battery {
    padding: 0 8px;
    color: {{ foreground }};
    border-radius: 4px;
    margin: 3px 0;
}

#custom-battery.charging {
    color: {{ color2 }};
}

#custom-battery.warning:not(.charging) {
    color: {{ color1 }};
}

#custom-battery.critical:not(.charging) {
    color: {{ color1 }};
    animation: blink 0.5s linear infinite alternate;
}



@keyframes blink {
    to {
        background-color: {{ color1 }};
        color: {{ background }};
    }
}

tooltip {
    background: rgba({{ background_rgb }}, 0.95);
    border: 1px solid {{ accent }};
    border-radius: 6px;
    color: {{ foreground }};
    font-size: 12px;
    padding: 8px;
}
