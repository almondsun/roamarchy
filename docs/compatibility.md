# Compatibility

## Current baseline

| Item | Value |
| --- | --- |
| Omarchy channel | Official Quattro alpha |
| Default repository branch | `quattro` |
| Last tested package version | `4.0.0.r1441.g9174fbf-1` |
| Last reviewed | 2026-07-29 |
| Hyprland configuration | Lua user overrides |
| Desktop shell | `omarchy-shell` with Quickshell plugins |

This record describes tested evidence, not a promise that every later Quattro
build is compatible. Re-run the maintenance review after each official update.

## Module review record

| Module | Upstream contract checked |
| --- | --- |
| Appearance | Quattro Hyprland/UWSM cursor propagation, XCursor fallback behavior, and SDDM cursor settings |
| Ente Auth | Quattro passwordless keyring template, SDDM autologin, GNOME Keyring 50 stdin unlock, and Ente Auth libsecret storage |
| Keyboard | Quattro Lua input/binding helpers and current default keybindings |
| Monitor layout | Quattro monitor watcher, Hyprland Lua API, and IPC output |
| Power profiles | Public `omarchy powerprofiles` commands and shell ownership |
| Proton VPN | Omarchy bar-widget manifest, `BarIndicator`, and Proton CLI behavior |
| Screen recordings | Public `OMARCHY_SCREENRECORD_DIR`, UWSM user environment loading, and OBS VA-API encoder discovery |
| Screenshots | Public `OMARCHY_SCREENSHOT_DIR` override and UWSM user environment loading |
| Terminal | Public terminal selection, current theme state, Kitty/Fish integration |

## Unsupported baselines

- Pre-Quattro Hyprland `.conf` customizations.
- Waybar-era widgets and layouts.
- The retired Roamarchy root power-profile service.
- Blind replacement of complete machine configuration.
- Machine-specific monitor connector names as portable policy.

If an official update removes or changes a required interface, mark the affected
module as unverified in this file before modifying a live system.
