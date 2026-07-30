# Screen recordings

## Behavior

Save Omarchy screen recordings under `~/Videos/recordings`. The destination is
home-relative and portable across compatible Omarchy systems.

For OBS Studio, prefer the installed GPU's hardware encoder and tune the
profile only after validating the target machine. The current reference system
uses an AMD Ryzen 3 5300U APU and records 1920x1080 at 30 frames per second
through OBS's zero-copy FFmpeg VA-API H.264 encoder. The OBS profile is
intentionally not tracked because its render-device path and appropriate video
geometry are hardware-specific.

Recording always consumes some GPU, memory, storage, and compositor capacity.
The reference profile minimizes overhead but does not promise zero performance
impact.

## Official sources to review

Before applying this module, check:

- `omarchy version`
- `obs --version`
- `/usr/share/omarchy/bin/omarchy-capture-screenrecording`
- `/usr/share/omarchy/default/uwsm/default`
- `/usr/share/omarchy/default/uwsm/env.d/10-omarchy`
- the installed OBS `obs-ffmpeg` encoder inventory and startup log
- the target machine's GPU driver, display modes, and existing OBS profiles
- the target machine's `~/.config/uwsm/env.d/`

Confirm that Omarchy still reads `OMARCHY_SCREENRECORD_DIR`, OBS still exposes
the selected hardware encoder, and the encoder completes a short test before
committing to a profile.

## Source and destination

| Repository source | Destination | Mode |
| --- | --- | --- |
| `files/.config/uwsm/env.d/90-roamarchy-screen-recordings` | `~/.config/uwsm/env.d/90-roamarchy-screen-recordings` | Copy |

The live OBS profile belongs under `~/.config/obs-studio/basic/profiles/`, but
it is machine-specific and has no repository payload.

## Install

Inspect existing overrides and back up a conflicting destination:

```bash
rg -n 'OMARCHY_SCREENRECORD_DIR' ~/.config/uwsm 2>/dev/null
test ! -e ~/.config/uwsm/env.d/90-roamarchy-screen-recordings ||
  cp ~/.config/uwsm/env.d/90-roamarchy-screen-recordings \
    ~/.config/uwsm/env.d/90-roamarchy-screen-recordings.bak
install -d ~/.config/uwsm/env.d ~/Videos/recordings
install -m 0644 \
  modules/screen-recordings/files/.config/uwsm/env.d/90-roamarchy-screen-recordings \
  ~/.config/uwsm/env.d/90-roamarchy-screen-recordings
```

Log out and back in so UWSM loads the destination override.

On hardware matching the reviewed AMD APU, start from this OBS recording
profile:

| Setting | Value |
| --- | --- |
| Output mode | Advanced |
| Recording type and path | Standard; `~/Videos/recordings` |
| Format | Hybrid MP4/MOV |
| Encoder | FFmpeg VA-API H.264 |
| Rate control and quality | CQP; QP 20 |
| Profile, keyframe interval, B-frames | High; 2 seconds; 2 |
| Canvas and output | 1920x1080 at 30 FPS |
| Color | NV12; Rec. 709; Partial |
| Audio | 48 kHz stereo; AAC 160 kbps |
| Preview | Disabled while recording |

Use a PipeWire monitor or window capture source. Re-run hardware discovery
instead of copying these OBS values to a different GPU.

## Validate

Validate the environment fragment and, after starting a new session, its live
value:

```bash
bash -n \
  modules/screen-recordings/files/.config/uwsm/env.d/90-roamarchy-screen-recordings
printenv OMARCHY_SCREENRECORD_DIR
```

Run a short OBS capture while exercising the intended workload. The OBS log
must show the VA-API encoder, the expected resolution and frame rate, no
encoding overload, and no skipped or dropped frames. Inspect the result with
`ffprobe` and confirm audio, motion quality, and acceptable application
responsiveness.

## Roll back

Restore the backed-up UWSM fragment if one existed; otherwise remove
`~/.config/uwsm/env.d/90-roamarchy-screen-recordings`. Log out and back in.
Omarchy will return to `XDG_VIDEOS_DIR`, or `$HOME/Videos` when it is unset.

Restore the previous OBS profile backup or select another profile in OBS.
Existing recordings are not moved or deleted.

## Update-sensitive assumptions

- Quattro continues honoring `OMARCHY_SCREENRECORD_DIR`.
- UWSM continues sourcing `~/.config/uwsm/env.d/*` after Omarchy's defaults.
- OBS continues exposing `ffmpeg_vaapi_tex` for supported AMD hardware.
- Environment changes continue requiring a new desktop session.
