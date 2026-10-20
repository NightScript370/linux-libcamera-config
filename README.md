# Camera Settings

A small GTK app for adjusting the picture of a laptop webcam that runs through
**libcamera's software ISP** and is shared with other apps by **v4l2-relayd**
(for example the setup from the `ov05c10-ipu6-cvs` repository).

- **Live preview** with sliders for **saturation**, **contrast** and **gamma**.
- **Save** writes the values into `/etc/v4l2-relayd` and restarts the service, so every app (browser, video calls) uses them.
- **Reset to defaults** and **Restart camera** (for when the camera gets stuck in other apps).
- The same features work from a terminal.

```bash
camera-settings
camera-settings --show
camera-settings --saturation 1.2 --contrast 1.1 --gamma 2.2
camera-settings --reset
camera-settings --restart
```

Running `camera-settings` with no arguments opens the window. `--show` prints the current values. `--reset` restores the defaults (1.0 / 1.15 / 2.2), and `--restart` restarts v4l2-relayd.

## Requirements

- A configured v4l2-relayd: `/etc/v4l2-relayd` with a `VIDEOSRC=` line that uses `libcamerasrc`.
- libcamera with its GStreamer plugin. Plugins in `/opt/libcamera` are picked up automatically.
- Python 3 with GTK 3 and GStreamer bindings (`python3-gi`, `gir1.2-gtk-3.0`, `gir1.2-gst-plugins-base-1.0`, `gstreamer1.0-gtk3`).
- polkit (`pkexec`).

## Install

```bash
./install.sh
```

It installs `/usr/local/bin/camera-settings`, a menu entry, a polkit policy, and the helper `/usr/local/libexec/camera-settings-apply`.

Remove it with `./uninstall.sh`.

## How it works

libcamera applies saturation, contrast and gamma only when a stream starts. The preview therefore restarts briefly about half a second after a slider stops moving.

While the preview is open the app holds the camera. Other apps can use it again once the window is closed. If another app is already streaming, the window says so and settings can still be saved.

Saving runs the helper through `pkexec`. The helper accepts only plain numbers in fixed ranges (saturation 0–2, contrast 0.5–2, gamma 1–3) and rewrites only the `VIDEOSRC=` line.

The polkit policy lets the user at the active local session run it **without a password**. Remote and inactive sessions need admin authentication. To require a password everywhere, change `<allow_active>yes</allow_active>` to `auth_admin_keep` in `io.github.camera_settings.policy`.

Busy detection looks at the runtime-PM state of OmniVision ACPI sensors (`i2c-OVTI*`). For other sensors, adjust `SENSOR_POWER_GLOB` in `camera-settings`. Without busy detection the preview simply reports an error if the camera is in use.

## License

GPL-2.0-only. See `LICENSE`.
