@define-color bg {{ background }};
@define-color fg {{ foreground }};
@define-color accent {{ accent }};
@define-color selected_bg {{ selection_background }};
@define-color selected_fg {{ selection_foreground }};
@define-color urgent {{ color1 }};
@define-color success {{ color2 }};
@define-color warning {{ color3 }};

* {
    background-color: @bg;
    color: @fg;
}

entry,
button,
.view,
.iconview {
    background-color: shade(@bg, 1.2);
    color: @fg;
}

entry:focus,
button:hover {
    border-color: @accent;
}

selection {
    background-color: @accent;
    color: @fg;
}
