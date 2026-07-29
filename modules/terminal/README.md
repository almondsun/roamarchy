# Terminal

## Behavior

- Use Kitty as the default terminal and launch Fish inside it.
- Initialize Starship with the pastel-powerline structure and Omarchy Nord
  colors.
- Show fastfetch once per interactive Kitty session.
- Render the included Tux GIF in fastfetch's normal logo column.

Shell history, scrollback, caches, and session state are intentionally excluded.

## Official sources to review

Before applying this module, check:

- `omarchy version`
- `omarchy install terminal --help`
- `/usr/share/omarchy/default/hypr/apps/terminals.lua`
- the current Omarchy theme-state layout under
  `~/.local/state/omarchy/current/`
- current Kitty, Fish, Starship, and fastfetch configuration documentation
- every target file listed below

## Sources and destinations

| Repository source | Destination | Mode |
| --- | --- | --- |
| `files/.config/kitty/kitty.conf` | `~/.config/kitty/kitty.conf` | Complete file |
| `files/.config/fish/config.fish` | `~/.config/fish/config.fish` | Complete file |
| `files/.config/starship.toml` | `~/.config/starship.toml` | Complete file |
| `files/.config/roamarchy/terminal/tux.gif` | `~/.config/roamarchy/terminal/tux.gif` | Complete asset |
| `snippets/.config/fastfetch/logo.jsonc` | `~/.config/fastfetch/config.jsonc` | Merge |

## Install

Install and select the supported terminal stack:

```bash
omarchy install terminal kitty
omarchy pkg add fish starship fastfetch
```

Back up all existing destinations. From the repository root, install the
complete files:

```bash
install -D -m 0644 modules/terminal/files/.config/kitty/kitty.conf \
  "$HOME/.config/kitty/kitty.conf"
install -D -m 0644 modules/terminal/files/.config/fish/config.fish \
  "$HOME/.config/fish/config.fish"
install -D -m 0644 modules/terminal/files/.config/starship.toml \
  "$HOME/.config/starship.toml"
install -D -m 0644 \
  modules/terminal/files/.config/roamarchy/terminal/tux.gif \
  "$HOME/.config/roamarchy/terminal/tux.gif"
```

Merge the `logo` object from the fastfetch snippet into the existing
`~/.config/fastfetch/config.jsonc`; preserve the target machine's module list.
Restart the terminal through the current public Omarchy command.

## Validate

```bash
fish --no-execute modules/terminal/files/.config/fish/config.fish
STARSHIP_CONFIG=modules/terminal/files/.config/starship.toml starship explain
file modules/terminal/files/.config/roamarchy/terminal/tux.gif
xdg-terminal-exec -- true
```

Open Kitty with `Super+Return`. It should start Fish, show fastfetch once with
the Tux logo, and display the Nord-colored Starship prompt. Run
`fastfetch --logo-recache true` if the image cache needs refreshing.

## Roll back

Restore every backed-up configuration file and asset, then run the current
`omarchy restart terminal` command. If Kitty was not previously the default,
use the current `omarchy install terminal` flow to select the former terminal.

## Update-sensitive assumptions

- Omarchy keeps the public terminal-selection command and current theme-state
  path.
- Kitty retains the remote-control socket and CSI-u key mapping syntax.
- Fish, Starship, and fastfetch retain the configuration interfaces used here.
