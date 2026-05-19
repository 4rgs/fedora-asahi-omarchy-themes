window {
    background-color: {{ background }};
}

window > box {
    background-color: {{ background }};
}

entry {
    background-color: {{ color0 }};
    color: {{ foreground }};
    border: 1px solid {{ accent }};
    border-radius: 6px;
    padding: 8px 12px;
    font-size: 14px;
}

entry:focus {
    border-color: {{ accent }};
}

button {
    background-color: {{ accent }};
    color: {{ background }};
    border: none;
    border-radius: 6px;
    padding: 8px 24px;
    font-weight: bold;
}

button:hover {
    background-color: {{ accent }};
}

label {
    color: {{ foreground }};
    font-size: 14px;
}

label.title {
    font-size: 24px;
    font-weight: bold;
}
