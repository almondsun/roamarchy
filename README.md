# Roamarchy

Roamarchy is an opinionated, documentation-first configuration profile for the
official **Omarchy Quattro alpha**. It keeps portable desktop customizations
reviewable and makes them straightforward to reproduce across compatible
Omarchy systems without treating a home directory as a backup.

The default branch is `quattro`. Pre-Quattro configurations are intentionally
out of scope.

> [!IMPORTANT]
> Omarchy Quattro is an alpha and its interfaces can change. Before applying
> any module, the user must read the current official documentation,
> inspect the installed Omarchy source relevant to that module, and compare the
> module with the target machine's existing configuration.

## Start here

1. Read [Getting started](docs/getting-started.md).
2. Confirm the target version against [Compatibility](docs/compatibility.md).
3. Select only the modules you want.
4. Follow each module's preflight, installation, validation, and rollback
   instructions.

There is deliberately no automatic installer. Blindly copying desktop
configuration is unsafe while Quattro is evolving; Roamarchy instead provides
destination-mapped files, mergeable snippets, and exact manual commands.

## Modules

| Module | Result | Delivery |
| --- | --- | --- |
| [Appearance](modules/appearance/README.md) | Bibata cursor policy | Hyprland snippet |
| [Keyboard](modules/keyboard/README.md) | Latin American layout, normal CapsLock, screenshot binding | Hyprland snippets |
| [Monitor layout](modules/monitor-layout/README.md) | Dynamic laptop/external layout and odd/even workspaces | User script and Hyprland snippets |
| [Power profiles](modules/power-profiles/README.md) | Quattro-owned AC/battery profile policy | Official Omarchy commands |
| [Proton VPN](modules/proton-vpn/README.md) | Quick Connect indicator beside official indicators | User-owned shell plugin |
| [Terminal](modules/terminal/README.md) | Kitty, Fish, Starship, and fastfetch profile | Complete files, one snippet, and an asset |

Every module is optional. Hardware-specific identifiers, secrets, auth state,
logs, histories, caches, and generated runtime data stay outside Git.

## Repository convention

```text
modules/<module>/
├── README.md   # preflight, behavior, installation, validation, rollback
├── files/      # complete files mapped from the target home directory
├── snippets/   # fragments that must be reviewed and merged
└── assets/     # optional module-owned resources
```

Paths below `files/` mirror their destination relative to the target user's
home directory. For example,
`files/.config/kitty/kitty.conf` maps to `~/.config/kitty/kitty.conf`.
Paths below `snippets/` identify the file into which the fragment belongs, but
the fragment must be merged rather than copied over the target file.

## Maintaining the profile

After every Omarchy update, use the review process in
[Maintenance](docs/maintenance.md). Update the tested version and module review
record only after the relevant official interfaces and local validations have
been checked again.
