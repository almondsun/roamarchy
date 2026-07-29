# Power Profiles

## Behavior

Use the highest available performance profile on AC power and balanced behavior
on battery. This is a policy-only module: Quattro owns the implementation
through `omarchy-shell`, UPower, and `power-profiles-daemon`.

No Roamarchy service or configuration file should compete with that official
ownership.

## Official sources to review

Before applying this policy, check:

- `omarchy version`
- `omarchy powerprofiles --help`
- the current `omarchy-powerprofiles-list` and `omarchy-powerprofiles-set`
  implementations under `/usr/share/omarchy/bin/`
- `/usr/share/omarchy/shell/plugins/services/battery/Service.qml`
- `/usr/share/omarchy/shell/plugins/panels/power/Panel.qml`
- `omarchy powerprofiles list --active-state`

## Apply

Use only profiles reported by the current machine:

```bash
omarchy powerprofiles list
omarchy powerprofiles set ac performance
omarchy powerprofiles set battery balanced
omarchy powerprofiles set autodetect
```

If firmware does not expose `performance`, retain Quattro's supported fallback
instead of writing CPU governors directly.

## Migration from pre-Quattro Roamarchy

Older Roamarchy versions installed a root timer that must not coexist with the
Quattro policy. Inspect each path before removing it:

```bash
systemctl status roamarchy-power-profile-root.timer
sudo systemctl disable --now roamarchy-power-profile-root.timer
sudo rm /etc/systemd/system/roamarchy-power-profile-root.timer
sudo rm /etc/systemd/system/roamarchy-power-profile-root.service
sudo rm /usr/local/bin/roamarchy-power-profile
sudo systemctl daemon-reload
```

These cleanup commands are only for a machine on which that retired service was
previously installed.

## Validate

```bash
omarchy powerprofiles list --active-state
powerprofilesctl get
```

The active profile must match the current power source and the saved Quattro
preference.

## Roll back

Choose different supported AC and battery preferences with
`omarchy powerprofiles set`, or return entirely to official automatic defaults
with `omarchy powerprofiles set autodetect`. Do not restore the retired root
service.

## Update-sensitive assumptions

- Quattro continues owning power-source transitions in `omarchy-shell`.
- The public `omarchy powerprofiles` command remains the configuration surface.
- Available profiles remain hardware-dependent.
