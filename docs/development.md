# Development

Roamarchy keeps its implementation small, but every change must pass the same
repository-native checks locally and in CI.

## Prerequisites

Run development checks on a compatible Omarchy Quattro system. Install the
additional static-analysis and test tools through Omarchy:

```bash
omarchy pkg add bats shellcheck shfmt stylua
```

The remaining commands used by the check suite are supplied by the documented
module prerequisites or the Omarchy baseline. `scripts/check` reports every
missing command before running any validation.

Ruff, Biome, staticcheck, and ast-grep are useful global tools, but they are not
repository dependencies while Roamarchy has no Python, JavaScript, TypeScript,
or Go source.

## Canonical check

From the repository root, run:

```bash
scripts/check
```

The command performs formatting and static analysis, validates structured
configuration and the Omarchy shell plugin, runs mocked monitor-layout behavior
tests, checks repository documentation and path policies, and finishes with
`git diff --check`. It never applies a module to the live system.

Runtime checks remain module-specific. A change to Hyprland behavior still
requires `hyprctl reload` and `hyprctl configerrors` on a compatible test
system, and a shell-plugin change still requires a rescan/restart and an
interactive behavior check.

## Continuous integration

GitHub Actions runs `scripts/check` in an Arch container for pull requests and
pushes to `quattro`. The workflow checks out the exact Omarchy source commit
encoded by the compatibility baseline so plugin schema and QML imports do not
float independently of `docs/compatibility.md`.

When the tested Omarchy baseline changes, update the workflow's full commit SHA
and `docs/compatibility.md` in the same change.
