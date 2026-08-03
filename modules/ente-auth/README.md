# Ente Auth

## Behavior

Install Ente Auth and keep GNOME Keyring in its encrypted binary format while
retaining Omarchy's one-password LUKS boot and SDDM autologin. A unique local
passphrase unlocks the keyring through stdin before the graphical session.

This module is only appropriate for a single-user system whose home directory
is protected at rest by LUKS. The passphrase file is private machine state and
must never be committed. The module affects the shared Secret Service used by
Chromium and other applications, not only Ente Auth.

## Official sources to review

Before applying this module, check:

- `omarchy version`, `omarchy pkg aur add --help`, and `omarchy pkg add --help`
- `/usr/share/omarchy/install/user/default-keyring.sh`
- `/usr/share/omarchy/install/login/sddm.sh`
- `/usr/lib/systemd/user/gnome-keyring-daemon.{service,socket}`
- `man gnome-keyring-daemon` and `man systemd.unit`
- the current GNOME Keyring `gkm-secret-textual.c` implementation
- Ente Auth's installed `flutter_secure_storage` and `libsecret` linkage
- the target machine's SDDM, PAM, keyring, browser, and autostart configuration

GNOME Keyring 50 and current upstream write textual UTF-8 secrets with
`g_key_file_set_value`; embedded newlines from Ente Auth, Proton SSO, or another
Secret Service client can invalidate a plaintext collection.

## Source and destination

| Repository source | Destination | Mode |
| --- | --- | --- |
| `files/.local/bin/roamarchy-repair-plaintext-keyring` | `~/.local/bin/roamarchy-repair-plaintext-keyring` | Copy, executable |
| `files/.local/bin/roamarchy-keyring-passphrase-init` | `~/.local/bin/roamarchy-keyring-passphrase-init` | Copy, executable |
| `files/.local/bin/roamarchy-keyring-unlock` | `~/.local/bin/roamarchy-keyring-unlock` | Copy, executable |
| `files/.config/systemd/user/gnome-keyring-daemon.service.d/90-roamarchy-encrypted-login.conf` | `~/.config/systemd/user/gnome-keyring-daemon.service.d/90-roamarchy-encrypted-login.conf` | Copy |

The untracked passphrase belongs at
`~/.local/share/roamarchy/gnome-keyring.passphrase` with mode `0600` and no
trailing newline.

## Install

Inspect the machine first. Do not launch Ente Auth or Chromium during keyring
conversion.

```bash
omarchy version
find ~/.local/share/keyrings -maxdepth 1 -type f -printf '%f %m %s bytes\n'
systemctl --user cat gnome-keyring-daemon.service
rg -n 'User=|Session=' /etc/sddm.conf.d
omarchy pkg aur add ente-auth-bin
omarchy pkg add seahorse
install -D -m 0755 modules/ente-auth/files/.local/bin/roamarchy-repair-plaintext-keyring ~/.local/bin/roamarchy-repair-plaintext-keyring
install -D -m 0755 modules/ente-auth/files/.local/bin/roamarchy-keyring-passphrase-init ~/.local/bin/roamarchy-keyring-passphrase-init
install -D -m 0755 modules/ente-auth/files/.local/bin/roamarchy-keyring-unlock ~/.local/bin/roamarchy-keyring-unlock
install -D -m 0644 modules/ente-auth/files/.config/systemd/user/gnome-keyring-daemon.service.d/90-roamarchy-encrypted-login.conf ~/.config/systemd/user/gnome-keyring-daemon.service.d/90-roamarchy-encrypted-login.conf
```

Close affected applications and make a mode-`0700` backup of the keyring
directory plus Chromium's `Cookies`, `Local State`, and `Preferences`. Repair
an existing malformed collection only with an explicit backup path.

Create a unique passphrase through the module's local no-echo prompt. Do not
reuse the Linux password or use clipboard history:

```bash
roamarchy-keyring-passphrase-init
```

In Seahorse, change the restored default keyring's password from blank to the
same unique passphrase. Then enable automatic unlock:

```bash
systemctl --user daemon-reload
systemctl --user restart gnome-keyring-daemon.service
```

Launch Ente Auth only after the encrypted keyring passes validation.

## Validate

```bash
systemd-analyze --user verify gnome-keyring-daemon.service
systemctl --user restart gnome-keyring-daemon.service
systemctl --user status gnome-keyring-daemon.service
file ~/.local/share/keyrings/*.keyring
journalctl --user -u gnome-keyring-daemon.service --since today | rg 'invalid or unrecognized' && exit 1 || true
```

Launch Ente Auth, let it update secure storage, restart the daemon, and repeat
the checks. Finally reboot: enter only the LUKS password and confirm SDDM
autologin, no keyring prompt, and intact Chromium and Ente sessions.

## Roll back

In Seahorse, change the keyring password from the unique passphrase to the
Linux login password. Remove the `gnome-keyring-daemon.service.d` drop-in,
helpers, and passphrase file, then remove the SDDM autologin drop-in. Reboot
and verify the standard LUKS-plus-SDDM flow. Never delete the passphrase before
changing the keyring password. Restore private keyring and Chromium backups
while their services are stopped if recovery fails.

## Update-sensitive assumptions

- Root and home data remain protected by LUKS.
- Omarchy continues using SDDM autologin on encrypted single-user systems.
- GNOME Keyring continues supporting `--unlock` through stdin.
- UWSM continues activating `default.target` before graphical applications.
- Ente Auth continues using Flutter Secure Storage through `libsecret`.
- Remove this workaround only after upstream and runtime validation prove that
  embedded newlines are safely serialized.
