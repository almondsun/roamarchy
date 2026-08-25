# Repository Instructions

## Purpose

Roamarchy is a documentation-first, opt-in configuration profile for Omarchy 4
(Quattro), currently validated against the rolling Edge channel. Preserve
portability and current upstream behavior; do not turn this repository into a
raw home-directory backup or an automatic installer.

## Mandatory preflight

Before changing or applying any module:

1. Read the root README, `docs/compatibility.md`, and that module's README.
2. Run `omarchy version` and confirm the installed release is still within the
   documented Quattro target.
3. Read current official information for the affected subsystem. Prefer the
   installed source under `/usr/share/omarchy/`, current command help, and the
   official Omarchy or upstream project documentation.
4. Inspect the target machine's existing configuration before proposing any
   copy, merge, or command.

Never edit `/usr/share/omarchy/`. It is packaged, update-managed source and is
read-only reference material for this repository.

## Repository contracts

- Keep each customization under `modules/<kebab-case-name>/`.
- Put complete, user-owned files under `files/` using home-relative destination
  paths.
- Put partial configuration under `snippets/` using the path of the file into
  which it must be merged.
- Keep machine identifiers, private authentication data, VPN profiles, caches,
  logs, histories, generated state, and backups out of Git.
- Preserve official components instead of copying them when an adjacent plugin,
  supported override, hook, or public command satisfies the requirement.
- Do not introduce an installer, dotfile manager, or symlink workflow without
  explicit approval.

## Documentation contract

Every module README must state:

- intended behavior and portability boundary;
- current official sources to inspect before application;
- prerequisites and destination mapping;
- manual installation steps that begin with inspection and backup;
- repository-native validation;
- exact rollback guidance;
- known update-sensitive assumptions.

When Omarchy behavior changes, update both the affected module and
`docs/compatibility.md`. Do not claim compatibility beyond validation evidence.

## Validation

Use the smallest relevant syntax and runtime checks for each changed module.
Run `scripts/check` for every repository change; it owns the canonical static,
formatting, behavioral, documentation-path, private-path, and diff checks.
Hyprland changes additionally require `hyprctl reload` followed by
`hyprctl configerrors`; Omarchy shell plugin changes additionally require a
shell rescan/restart and interactive validation on a test system.
