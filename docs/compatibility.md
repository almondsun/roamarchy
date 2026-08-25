# Compatibility

## Current baseline

| Item | Value |
| --- | --- |
| Omarchy release line | Omarchy 4 (Quattro), released as `4.0.0` |
| Tested package channel | Edge (`omarchy-dev` and `omarchy-settings-dev`) |
| Stable package channel | Released but not separately validated by Roamarchy |
| Default repository branch | `quattro` |
| Last tested package version | `4.0.0.r1834.g9301092-1` |
| Tested upstream commit | `93010924047d09f62f702bf8b5c07d0149c11943` |
| Last reviewed | 2026-08-25 |
| Hyprland configuration | Lua user overrides |
| Desktop shell | `omarchy-shell` with Quickshell `0.3.1-1` plugins |

This record describes tested Edge evidence, not a promise that every later
Edge build or the separately packaged Stable channel is compatible. Re-run the
maintenance review after each official update.

## Module review record

| Module | Upstream contract checked |
| --- | --- |
| Appearance | Omarchy 4 Hyprland/UWSM cursor propagation, XCursor fallback behavior, and SDDM cursor settings |
| Ente Auth | Omarchy 4 passwordless keyring template, SDDM autologin, GNOME Keyring 50 stdin unlock, and Ente Auth libsecret storage |
| Keyboard | Omarchy 4 Lua input/binding helpers and current default keybindings |
| Monitor layout | Omarchy 4 user monitor template, monitor watcher, Hyprland Lua API, and IPC output |
| Power profiles | Public `omarchy powerprofiles` commands and shell ownership |
| Proton VPN | Current plugin enable/disable and bar-placement commands, bar-widget manifest, `BarIndicator`, and Proton CLI behavior |
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
