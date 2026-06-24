# Terminal Policy

This directory documents portable terminal behavior for an Omarchy workstation.

## Behavior

- use Kitty as the default terminal emulator
- launch Fish inside Kitty
- initialize Starship for interactive Fish sessions
- use Starship's `pastel-powerline` preset structure with the Omarchy Nord
  palette and no decorative time prefix
- print fastfetch once when a new interactive Kitty session starts
- render `tux.gif` in fastfetch's normal logo column with the `kitty-icat`
  backend and a widened, aspect-preserving logo box

## Portability boundary

The durable policy is the terminal stack, prompt shape, theme-derived color
choice, startup fastfetch behavior, and the portable `tux.gif` asset. Shell
history, terminal scrollback, runtime caches, and machine-specific session state
belong to the target machine and should not be committed.

## Current implementation

The live machine applies this policy through:

- `~/.config/xdg-terminals.list`: keeps `kitty.desktop` first
- `~/.config/kitty/kitty.conf`: launches `fish`
- `~/.config/fish/config.fish`: initializes Starship and prints fastfetch once
  per interactive Kitty session with `--logo-recache true`
- `~/.config/starship.toml`: Starship `pastel-powerline` preset structure with
  Nord colors
- `~/.config/fastfetch/config.jsonc`: uses the `kitty-icat` logo backend with
  `~/.config/roamarchy/terminal/tux.gif`

The durable repo copies are:

- `terminal/kitty.conf`
- `terminal/config.fish`
- `terminal/starship.toml`
- `terminal/fastfetch-logo.jsonc`
- `terminal/tux.gif`

## Install on a machine

Review the target machine's terminal, shell, prompt, and fastfetch config before
installing this policy.

Install the durable files:

```bash
mkdir -p ~/.config/kitty ~/.config/fish ~/.config/fastfetch ~/.config/roamarchy/terminal
install -m 644 terminal/kitty.conf ~/.config/kitty/kitty.conf
install -m 644 terminal/config.fish ~/.config/fish/config.fish
install -m 644 terminal/starship.toml ~/.config/starship.toml
install -m 644 terminal/tux.gif ~/.config/roamarchy/terminal/tux.gif
```

Keep Kitty first for `xdg-terminal-exec`:

```text
kitty.desktop
```

Merge the logo block from `terminal/fastfetch-logo.jsonc` into
`~/.config/fastfetch/config.jsonc`, preserving the rest of the machine's
fastfetch module list unless the full display layout should also be replaced.

Validate after installation:

```bash
fish --no-execute ~/.config/fish/config.fish
starship explain
file ~/.config/roamarchy/terminal/tux.gif
xdg-terminal-exec -- true
```

From inside Kitty, run `fastfetch --logo-recache true` to verify the Tux GIF
appears in the normal fastfetch logo column. `Super+Return` should open Kitty,
start Fish, show fastfetch once with the Tux GIF logo, and use the Nord-colored
Starship prompt.
