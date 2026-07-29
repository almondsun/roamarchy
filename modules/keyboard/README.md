# Keyboard

## Behavior

- Use the Latin American keyboard layout.
- Keep CapsLock as normal CapsLock rather than Compose.
- Bind `Super+Shift+S` to an Omarchy screenshot.

The layout and shortcut are opinionated user choices. Input-device identifiers
and generated per-device state are not portable and do not belong here.

## Official sources to review

Before applying this module, check:

- `omarchy version`
- `omarchy menu keybindings --print`
- `/usr/share/omarchy/default/hypr/input.lua`
- `/usr/share/omarchy/default/hypr/bindings.lua` and its required modules
- current Hyprland input and binding documentation
- the target machine's `~/.config/hypr/input.lua` and `bindings.lua`

Confirm the current owner of `Super+Shift+S`; this baseline found it assigned to
Google Maps, which is why the snippet explicitly unbinds it first.

## Sources and destinations

| Repository source | Destination | Mode |
| --- | --- | --- |
| `snippets/.config/hypr/input.lua` | `~/.config/hypr/input.lua` | Merge |
| `snippets/.config/hypr/bindings.lua` | `~/.config/hypr/bindings.lua` | Merge |

## Install

Back up both destination files. Merge the input snippet, preserving a different
machine-specific layout if `latam` is not desired. Merge the binding snippet
only after checking the live keybinding list.

Apply the changes:

```bash
hyprctl reload
hyprctl configerrors
omarchy menu keybindings --print
```

## Validate

Hyprland must report no configuration errors. The keybinding list must show
`SUPER + SHIFT + S` for `Screenshot`, and pressing it must start the current
official Omarchy screenshot flow.

## Roll back

Restore both backed-up Hyprland files, run `hyprctl reload`, and confirm
`hyprctl configerrors` is empty. The original `Super+Shift+S` binding should
then return.

## Update-sensitive assumptions

- Quattro continues exposing the `hl.unbind`, `hl.config`, and `o.bind` helpers.
- `omarchy-capture-screenshot` remains the supported screenshot entrypoint.
- The official binding occupying `Super+Shift+S` may change between releases.
