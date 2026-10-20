#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
# Removes Camera Settings. Uses sudo. Camera settings already saved stay in effect.
sudo rm -f /usr/local/bin/camera-settings /usr/local/libexec/camera-settings-apply \
	/usr/share/polkit-1/actions/io.github.camera_settings.policy \
	/usr/share/applications/camera-settings.desktop
echo "Camera Settings removed."
