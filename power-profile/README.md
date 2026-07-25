# Power Profile Policy (Quattro)

## Behavior

Use the highest available performance policy while connected to AC power, and
use balanced behavior while running from battery.

Quattro owns this policy through `omarchy-shell`, UPower, and
`power-profiles-daemon`:

- AC power: `performance`
- battery: `balanced`

At Hyprland startup, Quattro applies the saved profile for the current power
source. The shell watches UPower and switches profiles again whenever AC power
is connected or removed. When no preference has been saved, Quattro selects
`performance` on AC if the platform exposes it and `balanced` otherwise.

Set or inspect the saved policy with the public Quattro CLI:

```bash
omarchy powerprofiles list
omarchy powerprofiles set ac performance
omarchy powerprofiles set battery balanced
omarchy powerprofiles set autodetect
```

Only profiles reported by `omarchy powerprofiles list` can be selected. If the
firmware or driver does not expose `performance`, Quattro safely falls back to
`balanced`; Roamarchy no longer writes kernel CPU governors directly.

## Remove the pre-Quattro service

The old `roamarchy-power-profile-root.timer` must not run alongside Quattro.
Both would react to the same power-source changes, while the root timer could
silently override a profile selected in the shell.

On a machine that installed the old repository version, review the unit names
and then remove them:

```bash
sudo systemctl disable --now roamarchy-power-profile-root.timer
sudo rm /etc/systemd/system/roamarchy-power-profile-root.timer
sudo rm /etc/systemd/system/roamarchy-power-profile-root.service
sudo rm /usr/local/bin/roamarchy-power-profile
sudo systemctl daemon-reload
```

Validate the Quattro-owned setup:

```bash
omarchy powerprofiles list --active-state
omarchy powerprofiles set autodetect
powerprofilesctl get
```

The active profile should match the current AC/battery source and the saved
Quattro preference.
