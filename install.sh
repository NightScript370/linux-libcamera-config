#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
# Installs Camera Settings (menu entry + `camera-settings` command). Uses sudo.
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
sudo sh -s "$here" <<'ROOT'
set -eu
here="$1"
install -m 755 "$here/camera-settings" /usr/local/bin/camera-settings
install -d /usr/local/libexec
install -m 755 "$here/camera-settings-apply" /usr/local/libexec/camera-settings-apply
install -m 644 "$here/io.github.camera_settings.policy" /usr/share/polkit-1/actions/io.github.camera_settings.policy
install -m 644 "$here/camera-settings.desktop" /usr/share/applications/camera-settings.desktop
update-desktop-database -q /usr/share/applications 2>/dev/null || true
ROOT
echo "Installed. Open \"Camera Settings\" from the menu, or run: camera-settings --help"
