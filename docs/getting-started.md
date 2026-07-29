# Getting Started

Roamarchy is applied module by module. It does not include an installer because
Quattro is an alpha and a future official update may change the configuration
contract a module relies on.

## 1. Clone the Quattro profile

```bash
git clone --branch quattro git@github.com:almondsun/roamarchy.git
cd roamarchy
```

## 2. Perform the mandatory preflight

Identify the installed build:

```bash
omarchy version
omarchy debug --no-sudo --print
```

Then, for every selected module:

1. Read its complete README.
2. Follow its **Official sources to review** section.
3. Compare its files or snippets with the live destination.
4. Stop if the installed interface contradicts the module documentation.

Use `/usr/share/omarchy/` only as a read-only source of truth. Never modify it.
For commands, prefer the public `omarchy <group> <action>` interface and inspect
current help before relying on an example:

```bash
omarchy commands
omarchy <group> --help
```

## 3. Understand files and snippets

A path below `files/` mirrors its destination relative to your home directory.
These are complete, user-owned files, but an existing destination must still be
reviewed and backed up before replacement.

A path below `snippets/` identifies the destination file but contains only the
Roamarchy-owned fragment. Merge it into the existing file; never overwrite the
destination with a snippet.

## 4. Back up before applying

Create a private backup directory and copy every destination that will change.
Use a descriptive timestamp so the module README's rollback commands can refer
to it:

```bash
backup_tag=$(date +%Y%m%d-%H%M%S)
install -d -m 0700 "$HOME/.local/state/roamarchy/backups/$backup_tag"
```

Keep backups, machine identifiers, secrets, and downloaded VPN profiles outside
the repository.

## 5. Apply and validate one module at a time

Follow the module README exactly. Validate before proceeding to another module,
and roll back immediately if the target application reports errors.

Do not run `omarchy refresh <component>` as a normal installation step. Refresh
commands reset user configuration to official defaults and should be used only
after reviewing their current behavior and accepting the reset.
