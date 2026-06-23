# roamarchy

`roamarchy` is a personal, migration-friendly workspace for durable Omarchy
configuration and workstation setup notes.

This repository preserves the parts of a Linux desktop setup that are worth
versioning, reviewing, and reapplying on compatible machines. It is not intended
to be a raw home-directory backup.

## Scope

Keep this repository focused on human-managed configuration and documentation:

- portable Omarchy, Hyprland, Waybar, launcher, terminal, and desktop behavior
  settings
- workstation setup notes that explain why a setting exists
- scripts or templates that safely recreate durable configuration
- validation notes for checking that a machine was configured correctly

Exclude local-only or sensitive runtime state:

- secrets, tokens, keys, and session material
- logs, caches, histories, screenshots, and temporary files
- generated runtime state from desktop services
- machine-specific device identifiers unless they are documented as examples
- package manager caches, build outputs, and local virtual environments
- raw home-directory copies that have not been curated for portability

If a file is only useful on one machine, document the local setup requirement
instead of committing the machine-local artifact.

## Current structure

```text
.
`-- monitors/
```

What each area means:

- `monitors/`: portable monitor layout policy and behavior notes for laptop and
  external-display setups.

## Migration intent

The goal is to make a new compatible workstation feel familiar without copying
private or fragile runtime state.

The intended workflow is:

1. clone this repository on the target machine
2. review the relevant documentation before applying any configuration
3. copy or link only the desired durable files into the real Omarchy and desktop
   configuration locations
4. regenerate runtime state locally by starting the relevant applications and
   services
5. keep secrets, logs, caches, and machine-local data outside version control

Do not blindly overwrite a live desktop configuration. Review the target
machine's existing files first, especially monitor, keyboard, theme, shell, and
launcher settings that may depend on hardware or local preferences.

## Publishing note

Before publishing updates, review changes for:

- secrets or auth state
- private paths, hostnames, or device identifiers
- screenshots or logs that reveal sensitive information
- machine-specific assumptions that should be documented rather than committed

This repo should read like a curated portable workstation baseline, not a dump
of a live home directory.
