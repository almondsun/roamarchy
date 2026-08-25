# Monitor Layout

## Behavior

On the laptop alone, use the internal panel at its best available mode with
scale `1`. With an external monitor:

- place the external monitor to the left and make workspace `1` start there;
- keep the laptop panel to the right;
- assign odd workspaces to the external display and even workspaces to the
  laptop display;
- select the highest advertised resolution and refresh rate at scale `1`.

The first active non-`eDP*` output is treated as the external display.
Connector names and detected modes remain machine-local runtime state.

## Official sources to review

Before applying this module, check:

- `omarchy version`
- `/usr/share/omarchy/config/hypr/monitors.lua`
- `/usr/share/omarchy/default/hypr/autostart.lua`
- `/usr/share/omarchy/bin/omarchy-hyprland-monitor-watch`
- current Hyprland monitor, workspace-rule, dispatch, and IPC documentation
- `hyprctl monitors all`, `hyprctl workspaces`, and the target Hyprland files

Quattro's monitor watcher must remain enabled. Roamarchy adds layout and
workspace placement; it does not replace official clamshell or monitor-toggle
recovery.

## Sources and destinations

| Repository source | Destination | Mode |
| --- | --- | --- |
| `files/.local/bin/roamarchy-monitor-layout` | `~/.local/bin/roamarchy-monitor-layout` | Complete file |
| `snippets/.config/hypr/monitors.lua` | `~/.config/hypr/monitors.lua` | Merge |
| `snippets/.config/hypr/autostart.lua` | `~/.config/hypr/autostart.lua` | Merge |

## Install

Commands below run from the repository root. Back up every existing destination
before continuing.

```bash
install -D -m 0755 \
  modules/monitor-layout/files/.local/bin/roamarchy-monitor-layout \
  "$HOME/.local/bin/roamarchy-monitor-layout"
```

Merge both snippets into their target Hyprland files. The autostart snippet
starts the watcher in future sessions. Apply the policy once in the current
session:

```bash
"$HOME/.local/bin/roamarchy-monitor-layout" apply
```

Set `ROAMARCHY_WORKSPACE_LIMIT` in the launch environment before the watcher
starts if more than the default 20 managed workspaces are required. The value
must be a positive integer.

## Validate

```bash
scripts/check
hyprctl reload
hyprctl configerrors
hyprctl monitors
hyprctl workspacerules
```

Hyprland must report no configuration errors. Active managed displays should
use scale `1`, and workspace rules should match the connected-monitor policy.
Reconnect the external display once to test the watcher.

## Roll back

Stop the Roamarchy watcher, restore the backed-up `monitors.lua` and
`autostart.lua`, and restore or move aside the installed user script. Run
`hyprctl reload` and `hyprctl configerrors`. Start a fresh Hyprland session if
runtime workspace rules from the watcher remain active.

## Update-sensitive assumptions

- Hyprland keeps the current Lua `hl.monitor`, workspace-rule, and dispatch API.
- Monitor JSON retains the fields and mode strings consumed by the helper.
- Hyprland's event socket continues emitting the monitored event names.
- Quattro keeps its own monitor watcher active alongside user autostart entries.
