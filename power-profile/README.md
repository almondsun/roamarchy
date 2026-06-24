# Power Profile Policy

## Behavior

Use the highest available performance policy while connected to AC power, and
use balanced behavior while running from battery.

The preferred backend is `powerprofilesctl` when it exposes the needed
profiles:

- AC power: `performance`
- battery: `balanced`

On this laptop, `powerprofilesctl list` currently exposes only `balanced` and
`power-saver`, so the live implementation runs as a root systemd timer and uses
the kernel CPU frequency governor fallback:

- AC power: write `performance` to all CPU `scaling_governor` files
- battery: write the first available balanced governor, preferring `schedutil`
  then `ondemand`, `conservative`, and `powersave`

If `power-profiles-daemon` later exposes a real `performance` profile, the same
script will also use it.

## Current implementation

The live machine runs `/usr/local/bin/roamarchy-power-profile` from a system
systemd timer every 30 seconds. It needs root privileges so it can write CPU
frequency governors when `power-profiles-daemon` does not expose a performance
profile.

Durable files:

- `power-profile/roamarchy-power-profile`
- `power-profile/roamarchy-power-profile-root.service`
- `power-profile/roamarchy-power-profile-root.timer`

## Install on a machine

Install the system-level service when performance must be forced even though
`powerprofilesctl` does not expose a performance profile:

```bash
sudo install -m 755 power-profile/roamarchy-power-profile /usr/local/bin/roamarchy-power-profile
sudo install -m 644 power-profile/roamarchy-power-profile-root.service /etc/systemd/system/roamarchy-power-profile-root.service
sudo install -m 644 power-profile/roamarchy-power-profile-root.timer /etc/systemd/system/roamarchy-power-profile-root.timer
sudo systemctl daemon-reload
sudo systemctl enable --now roamarchy-power-profile-root.timer
sudo systemctl start roamarchy-power-profile-root.service
```

Validate:

```bash
systemctl show roamarchy-power-profile-root.service -p ActiveState -p SubState -p Result -p ExecMainStatus
systemctl show roamarchy-power-profile-root.timer -p ActiveState -p UnitFileState
cat /root/.local/state/roamarchy/power-profile
for governor in /sys/devices/system/cpu/cpufreq/policy*/scaling_governor; do
  printf '%s=' "$governor"
  cat "$governor"
done
```

Expected current-machine state while charging:

```text
ac: cpufreq-governor=performance
```

All `scaling_governor` files should report `performance` while AC power is
online. The root service is a oneshot, so `ActiveState=inactive` with
`Result=success` is the expected successful state after a run.

## Live machine state

The earlier unprivileged user timer was intentionally disabled because it
cannot force CPU governors. The root timer owns the policy on this machine:

```bash
systemctl show roamarchy-power-profile-root.timer -p ActiveState -p UnitFileState
systemctl --user show roamarchy-power-profile.timer -p ActiveState -p UnitFileState
```
