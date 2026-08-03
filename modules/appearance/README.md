# Appearance

## Behavior

Use the `Bibata-Modern-Ice` XCursor theme at 24 pixels across the Hyprland
session, applications that ask for the `default` XCursor theme, and the SDDM
login screen.

The module contains a mergeable Hyprland snippet and a user-owned XCursor
fallback file. SDDM support is an explicit administrator-owned drop-in because
the login screen runs before the user session. Plymouth has already exited by
the time the graphical login cursor appears.

The SDDM step applies only to systems using SDDM with a system-wide Bibata
installation. This module does not own the target machine's complete
look-and-feel or display-manager configuration.

## Official sources to review

Before applying this module, check:

- `omarchy version`
- `/usr/share/omarchy/default/hypr/looknfeel.lua`
- `/usr/share/omarchy/default/hypr/envs.lua`
- `/usr/lib/sddm/sddm.conf.d/default.conf`
- `/etc/sddm.conf.d/10-theme.conf`
- `man sddm.conf` and `man Xcursor`
- current Hyprland environment-variable and cursor documentation
- the target machine's `~/.config/hypr/looknfeel.lua`
- any existing `~/.local/share/icons/default/index.theme`
- any existing `/etc/sddm.conf.d/90-roamarchy-cursor.conf`

Stop and reassess the snippet if Quattro adds an official cursor command or
changes how user environment overrides or its SDDM theme are loaded.

## Source and destination

| Repository source | Destination | Mode |
| --- | --- | --- |
| `snippets/.config/hypr/looknfeel.lua` | `~/.config/hypr/looknfeel.lua` | Merge |
| `files/.local/share/icons/default/index.theme` | `~/.local/share/icons/default/index.theme` | Copy |

The SDDM drop-in is created manually under `/etc` because it is
administrator-owned configuration, not a home-relative repository payload.

## Install

Inspect the current configuration and back up every existing destination before
changing it:

```bash
omarchy version
sed -n '1,160p' /usr/share/omarchy/default/hypr/envs.lua
sed -n '1,180p' ~/.config/hypr/looknfeel.lua
gsettings get org.gnome.desktop.interface cursor-theme
gsettings get org.gnome.desktop.interface cursor-size
sudo sed -n '1,80p' /etc/sddm.conf.d/10-theme.conf
test ! -e ~/.local/share/icons/default/index.theme ||
  sed -n '1,80p' ~/.local/share/icons/default/index.theme
test ! -e /etc/sddm.conf.d/90-roamarchy-cursor.conf ||
  sudo sed -n '1,80p' /etc/sddm.conf.d/90-roamarchy-cursor.conf
backup_stamp=$(date +%Y%m%d%H%M%S)
cp -a ~/.config/hypr/looknfeel.lua \
  ~/.config/hypr/looknfeel.lua.bak."$backup_stamp"
test ! -e ~/.local/share/icons/default/index.theme ||
  cp -a ~/.local/share/icons/default/index.theme \
    ~/.local/share/icons/default/index.theme.bak."$backup_stamp"
test ! -e /etc/sddm.conf.d/90-roamarchy-cursor.conf ||
  sudo cp -a /etc/sddm.conf.d/90-roamarchy-cursor.conf \
    /etc/sddm.conf.d/90-roamarchy-cursor.conf.bak."$backup_stamp"
```

Install the cursor package and the user-level `default` fallback:

```bash
omarchy pkg aur add bibata-cursor-theme-bin
install -D -m 0644 \
  modules/appearance/files/.local/share/icons/default/index.theme \
  ~/.local/share/icons/default/index.theme
```

With the backup complete, merge the snippet into the existing
`looknfeel.lua`, then apply the matching GTK and current-session settings:

```bash
gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice
gsettings set org.gnome.desktop.interface cursor-size 24
hyprctl setcursor Bibata-Modern-Ice 24
hyprctl reload
```

Bibata supplies an XCursor theme, so the snippet sets `XCURSOR_THEME` and
`XCURSOR_SIZE` without claiming a native Hyprcursor theme. UWSM's Hyprland
plugin finalizes these variables into the user service environment, so a
separate UWSM environment override is not needed.

If the machine uses SDDM, add a separate drop-in without editing Omarchy's
package-owned `10-theme.conf`:

```bash
sudo tee /etc/sddm.conf.d/90-roamarchy-cursor.conf >/dev/null <<'EOF'
[Theme]
CursorTheme=Bibata-Modern-Ice
CursorSize=24
EOF
```

Restart applications that were already running before the fallback file was
installed. Check the SDDM result at the next logout or reboot; restarting SDDM
from the active desktop terminates the session.

## Validate

```bash
grep -Fx 'Inherits=Bibata-Modern-Ice' \
  ~/.local/share/icons/default/index.theme
hyprctl configerrors
gsettings get org.gnome.desktop.interface cursor-theme
gsettings get org.gnome.desktop.interface cursor-size
systemctl --user show-environment |
  grep -E '^(XCURSOR_THEME=Bibata-Modern-Ice|XCURSOR_SIZE=24)$'
sudo grep -Ex \
  'CursorTheme=Bibata-Modern-Ice|CursorSize=24' \
  /etc/sddm.conf.d/90-roamarchy-cursor.conf
```

Hyprland should report no configuration errors and both GTK values should match
the policy above. Restart Steam and verify the cursor remains Bibata throughout
its normal library and store UI. At the next logout or reboot, verify SDDM uses
Bibata before login and the desktop retains Bibata afterward.

## Roll back

Restore the backed-up user configuration and previous GTK values:

```bash
backup_stamp=TIMESTAMP_RECORDED_DURING_INSTALL
cp -a ~/.config/hypr/looknfeel.lua.bak."$backup_stamp" \
  ~/.config/hypr/looknfeel.lua
if test -e ~/.local/share/icons/default/index.theme.bak."$backup_stamp"; then
  mv ~/.local/share/icons/default/index.theme.bak."$backup_stamp" \
    ~/.local/share/icons/default/index.theme
else
  rm ~/.local/share/icons/default/index.theme
  rmdir --ignore-fail-on-non-empty ~/.local/share/icons/default
fi
gsettings set org.gnome.desktop.interface cursor-theme PREVIOUS_THEME
gsettings set org.gnome.desktop.interface cursor-size PREVIOUS_SIZE
```

If the SDDM drop-in existed previously, restore its backup. Otherwise remove
the module-created drop-in:

```bash
if test -e \
  /etc/sddm.conf.d/90-roamarchy-cursor.conf.bak."$backup_stamp"; then
  sudo mv \
    /etc/sddm.conf.d/90-roamarchy-cursor.conf.bak."$backup_stamp" \
    /etc/sddm.conf.d/90-roamarchy-cursor.conf
else
  sudo rm /etc/sddm.conf.d/90-roamarchy-cursor.conf
fi
hyprctl reload
hyprctl configerrors
```

Replace `TIMESTAMP_RECORDED_DURING_INSTALL`, `PREVIOUS_THEME`, and
`PREVIOUS_SIZE` with the values recorded during preflight. Restart Steam, then
check the restored SDDM cursor at the next logout or reboot.

## Update-sensitive assumptions

- Quattro continues loading user `looknfeel.lua` after its defaults.
- Hyprland continues accepting XCursor environment overrides.
- UWSM continues finalizing Hyprland's XCursor variables for user services.
- XCursor continues searching `~/.local/share/icons` before system icon paths.
- SDDM continues accepting `CursorTheme` and `CursorSize` in `[Theme]`.
- Quattro does not yet expose an official persistent cursor-selection command.
