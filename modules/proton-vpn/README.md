# Proton VPN

## Behavior

Add a Proton VPN Quick Connect indicator immediately after Omarchy's official
center indicators. The official `omarchy.indicators` widget remains untouched
and continues receiving upstream updates. `local.proton-vpn` is a separate,
user-owned plugin that adopts the current `BarIndicator` appearance and shared
center-hover reveal.

Clicking the icon connects to Proton's fastest suitable server or disconnects
the active tunnel. NetworkManager status polls and Proton actions have hard
timeouts so the UI cannot remain busy indefinitely.

## Official sources to review

Before applying this module, check:

- `omarchy version`
- `omarchy plugin --help` and `omarchy bar plugin --help`
- `/usr/share/omarchy/shell/Ui/BarIndicator.qml`
- `/usr/share/omarchy/shell/plugins/bar/widgets/Indicators.qml`
- `/usr/share/omarchy/shell/plugins/bar/widgets/Indicators.manifest.json`
- the current Proton VPN Linux app and CLI documentation
- the target `~/.config/omarchy/shell.json` and user plugin directory

Confirm the manifest, bar layout, and `BarIndicator` contracts still match the
plugin before copying it.

## Source and destination

| Repository source | Destination | Mode |
| --- | --- | --- |
| `files/.config/omarchy/plugins/local.proton-vpn/` | `~/.config/omarchy/plugins/local.proton-vpn/` | Complete plugin |

## Prerequisites

```bash
omarchy pkg add proton-vpn-gtk-app proton-vpn-cli
```

Open Proton VPN once and sign in. Then choose **Quit** from its menu; closing
the window may only hide it in the tray. The desktop app and CLI cannot control
the session concurrently, and this plugin deliberately uses the CLI.

## Install

Back up an existing plugin with the same ID and the current
`~/.config/omarchy/shell.json`. From the repository root:

```bash
install -D -m 0644 \
  modules/proton-vpn/files/.config/omarchy/plugins/local.proton-vpn/Widget.qml \
  "$HOME/.config/omarchy/plugins/local.proton-vpn/Widget.qml"
install -D -m 0644 \
  modules/proton-vpn/files/.config/omarchy/plugins/local.proton-vpn/manifest.json \
  "$HOME/.config/omarchy/plugins/local.proton-vpn/manifest.json"
omarchy plugin rescan
omarchy bar plugin add local.proton-vpn --after omarchy.indicators
omarchy restart shell
```

`omarchy refresh shell` resets the complete bar layout. After an intentional
refresh, inspect the new official defaults, rescan the plugin, and add it again.

## Validate

Validate the repository copy before installation:

```bash
omarchy plugin validate \
  modules/proton-vpn/files/.config/omarchy/plugins/local.proton-vpn
qmllint -I /usr/share/omarchy/shell \
  modules/proton-vpn/files/.config/omarchy/plugins/local.proton-vpn/Widget.qml
```

After installation, confirm the shell layout places `local.proton-vpn`
immediately after `omarchy.indicators`. With the Proton desktop app quit, test
one connect and disconnect cycle. The connected icon must persist, and either
operation must leave the busy state within 30 seconds.

## Roll back

```bash
omarchy bar plugin remove local.proton-vpn
omarchy plugin rescan
omarchy restart shell
```

Move the installed plugin directory out of `~/.config/omarchy/plugins/`, or
restore its backup if it existed before Roamarchy. Restore the backed-up
`shell.json` only if the layout command changed more than the Proton entry.

## Update-sensitive assumptions

- Omarchy retains the current bar-widget manifest and layout interfaces.
- `BarIndicator` retains the reveal and bar-host properties used by the plugin.
- Proton CLI retains `connect` and `disconnect`, and NetworkManager exposes the
  active tunnel as connected device `proton0`.
- Proton's desktop app and CLI remain mutually exclusive controllers.

Downloaded WireGuard profiles and account state are machine-local and must not
be committed.
