# Appearance Policy

## Cursor

Use the `Bibata-Modern-Ice` XCursor theme at 24 pixels.

Quattro does not currently provide a cursor-selection command. Install Bibata
through Omarchy's AUR package interface:

```bash
omarchy pkg aur add bibata-cursor-theme-bin
```

Merge `appearance/looknfeel.lua` into `~/.config/hypr/looknfeel.lua`. Apply the
same theme to GTK and the running Hyprland session:

```bash
gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice
gsettings set org.gnome.desktop.interface cursor-size 24
hyprctl setcursor Bibata-Modern-Ice 24
hyprctl reload
hyprctl configerrors
```

The package supplies XCursor themes, not native Hyprcursor themes, so the
durable override sets `XCURSOR_THEME` and leaves `HYPRCURSOR_THEME` unset.
