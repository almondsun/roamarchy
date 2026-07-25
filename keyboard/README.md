# Keyboard Policy

This directory documents portable keyboard behavior for a laptop-first Omarchy
setup.

## Behavior

- keep the existing `latam` keyboard layout
- make CapsLock behave as normal CapsLock, not as a Compose key
- add `Super+Shift+S` as a screenshot shortcut

## Portability boundary

The durable policy is the keyboard option override and the screenshot shortcut.
Generated input-device state, hardware IDs, and per-device runtime details
belong to the target machine and should not be committed as authoritative
configuration.

## Current implementation

Quattro loads personal Hyprland overrides from Lua modules after the Omarchy
defaults. The input policy belongs in `~/.config/hypr/input.lua`:

```lua
hl.config({
  input = {
    kb_layout = "latam",
    kb_options = "",
  },
})
```

Quattro assigns `Super+Shift+S` to Google Maps by default. The screenshot
override in `~/.config/hypr/bindings.lua` must therefore unbind it first:

```lua
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")
```

The durable snippets are:

- `keyboard/input.lua`
- `keyboard/bindings.lua`

## Install on a machine

Review the target machine's existing Hyprland input and binding configuration
before installing this policy.

Merge the durable input snippet into `~/.config/hypr/input.lua`, preserving any
target-machine layout choice if it should not be `latam`. The important setting
for normal CapsLock behavior is:

```lua
kb_options = ""
```

Merge the durable binding snippet into `~/.config/hypr/bindings.lua`. Check
first that `Super+Shift+S` is not already used:

```bash
omarchy menu keybindings --print
```

Validate after installation:

```bash
hyprctl reload
hyprctl configerrors
omarchy menu keybindings --print
```

`hyprctl configerrors` should not report any errors, and the keybinding list
should include `SUPER + SHIFT + S` for screenshots instead of Google Maps.
