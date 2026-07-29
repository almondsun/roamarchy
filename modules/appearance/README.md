# Appearance

## Behavior

Use the `Bibata-Modern-Ice` XCursor theme at 24 pixels. This module contains a
mergeable Hyprland snippet; it does not own the target machine's complete
look-and-feel configuration.

## Official sources to review

Before applying this module, check:

- `omarchy version`
- `/usr/share/omarchy/default/hypr/looknfeel.lua`
- `/usr/share/omarchy/default/hypr/envs.lua`
- current Hyprland environment-variable and cursor documentation
- the target machine's `~/.config/hypr/looknfeel.lua`

Stop and reassess the snippet if Quattro adds an official cursor command or
changes how user environment overrides are loaded.

## Source and destination

| Repository source | Destination | Mode |
| --- | --- | --- |
| `snippets/.config/hypr/looknfeel.lua` | `~/.config/hypr/looknfeel.lua` | Merge |

## Install

Install the cursor package:

```bash
omarchy pkg aur add bibata-cursor-theme-bin
```

Back up the destination, then merge the snippet into the existing
`looknfeel.lua`. Apply the matching GTK and current-session settings:

```bash
gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice
gsettings set org.gnome.desktop.interface cursor-size 24
hyprctl setcursor Bibata-Modern-Ice 24
hyprctl reload
```

Bibata supplies an XCursor theme, so the snippet sets `XCURSOR_THEME` and
`XCURSOR_SIZE` without claiming a native Hyprcursor theme.

## Validate

```bash
hyprctl configerrors
gsettings get org.gnome.desktop.interface cursor-theme
gsettings get org.gnome.desktop.interface cursor-size
```

Hyprland should report no configuration errors and both GTK values should match
the policy above.

## Roll back

Restore the backed-up `~/.config/hypr/looknfeel.lua`, restore the previous GTK
cursor name and size, then run `hyprctl reload` and `hyprctl configerrors`.

## Update-sensitive assumptions

- Quattro continues loading user `looknfeel.lua` after its defaults.
- Hyprland continues accepting XCursor environment overrides.
- Quattro does not yet expose an official persistent cursor-selection command.
