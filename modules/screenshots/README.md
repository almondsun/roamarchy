# Screenshots

## Behavior

Save every file-producing Omarchy screenshot capture under
`~/Pictures/screenshots`. Copy-only captures continue to use the clipboard
without creating a file.

The destination is home-relative and portable across compatible Omarchy
systems. This module does not change screenshot keybindings, capture modes,
file names, or the screenshot editor.

## Official sources to review

Before applying this module, check:

- `omarchy version`
- `/usr/share/omarchy/bin/omarchy-capture-screenshot`
- `/usr/share/omarchy/default/uwsm/default`
- `/usr/share/omarchy/default/uwsm/env.d/10-omarchy`
- the target machine's `~/.config/uwsm/env.d/`
- the target machine's current `OMARCHY_SCREENSHOT_DIR` session value

Confirm that the capture command still reads `OMARCHY_SCREENSHOT_DIR` and that
Omarchy still loads user UWSM environment fragments after its defaults.

## Source and destination

| Repository source | Destination | Mode |
| --- | --- | --- |
| `files/.config/uwsm/env.d/90-roamarchy-screenshots` | `~/.config/uwsm/env.d/90-roamarchy-screenshots` | Copy |

## Install

Inspect the existing UWSM user environment and back up a conflicting
destination before copying:

```bash
rg -n 'OMARCHY_SCREENSHOT_DIR' ~/.config/uwsm 2>/dev/null
test ! -e ~/.config/uwsm/env.d/90-roamarchy-screenshots ||
  cp ~/.config/uwsm/env.d/90-roamarchy-screenshots \
    ~/.config/uwsm/env.d/90-roamarchy-screenshots.bak
install -d ~/.config/uwsm/env.d ~/Pictures/screenshots
install -m 0644 \
  modules/screenshots/files/.config/uwsm/env.d/90-roamarchy-screenshots \
  ~/.config/uwsm/env.d/90-roamarchy-screenshots
```

Log out and back in so the UWSM session loads the environment override.

## Validate

After starting the new session:

```bash
printenv OMARCHY_SCREENSHOT_DIR
omarchy capture screenshot
```

The environment value must be `$HOME/Pictures/screenshots`, and a saved capture
must appear there. Cancel the interactive capture if runtime validation is not
appropriate.

## Roll back

Restore the backed-up destination if one existed; otherwise remove
`~/.config/uwsm/env.d/90-roamarchy-screenshots`. Log out and back in. Omarchy
will return to `XDG_PICTURES_DIR`, or `$HOME/Pictures` when that value is
unset. Existing screenshot files are not moved or deleted.

## Update-sensitive assumptions

- Quattro continues honoring `OMARCHY_SCREENSHOT_DIR`.
- UWSM continues sourcing `~/.config/uwsm/env.d/*` after Omarchy's defaults.
- Environment changes continue requiring a new desktop session.
