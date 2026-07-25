# Monitor Layout Policy

This directory documents portable monitor behavior for a laptop-first Omarchy
setup. Keep hardware-specific identifiers out of the committed policy unless
they are clearly marked as examples.

## Behavior

When no external monitor is connected, use the laptop panel at its best
available mode with scale `1`.

When an external monitor is connected:

- make the external monitor the primary monitor, so `Super+1` targets that
  display
- place the external monitor to the left of the laptop panel
- assign odd-numbered workspaces (`1`, `3`, `2n+1`) to the external monitor
- assign even-numbered workspaces (`2`, `4`, `2n`) to the laptop monitor
- select the maximum supported resolution and refresh rate detected for each
  display
- scale both displays at `1`

## Portability boundary

The durable policy is the workspace assignment, scale `1`, and "best available
mode" behavior. The generated monitor state, connector IDs, and runtime display
detection results belong to the target machine and should not be committed as
authoritative configuration unless they are intentionally generalized.

## Current implementation

Quattro's own `omarchy-hyprland-monitor-watch` continues to own clamshell and
monitor-toggle recovery. This policy adds only layout and workspace placement:

- `monitors/monitors.lua` establishes the portable preferred-mode, scale-1
  baseline
- `~/.local/bin/roamarchy-monitor-layout watch` applies the dynamic policy
- `monitors/autostart.lua` starts that watcher from
  `~/.config/hypr/autostart.lua`

The watcher detects the internal `eDP*` display, treats the first active
non-internal display as external, applies the highest available mode by pixel
area and refresh rate, and assigns both displays to scale `1`. It assigns
workspaces `1` through `20` by odd/even parity. When the external display is
removed, all managed workspaces are reassigned to the internal panel. Set
`ROAMARCHY_WORKSPACE_LIMIT` before launch if a machine needs a wider workspace
range.

## Install on a machine

Review the target machine's existing Quattro Hyprland monitor and autostart
configuration before installing this policy.

Install the durable script into the user runtime path:

```bash
install -m 755 monitors/roamarchy-monitor-layout ~/.local/bin/roamarchy-monitor-layout
```

Merge `monitors/monitors.lua` into `~/.config/hypr/monitors.lua`.

Merge this line from `monitors/autostart.lua` into
`~/.config/hypr/autostart.lua`:

```lua
o.launch_on_start(os.getenv("HOME") .. "/.local/bin/roamarchy-monitor-layout watch")
```

Apply once in the current Hyprland session:

```bash
~/.local/bin/roamarchy-monitor-layout apply
```

Validate after installation:

```bash
bash -n ~/.local/bin/roamarchy-monitor-layout
hyprctl monitors
hyprctl workspacerules
hyprctl reload
hyprctl configerrors
```

`hyprctl configerrors` should not report any errors. The active monitor output
should show scale `1` on managed displays. Quattro's own monitor watcher should
remain enabled; this policy does not replace it.
