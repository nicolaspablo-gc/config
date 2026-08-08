#!/usr/bin/env bash
#
# Installs a standalone "Firefox Profile Picker" app entry in GNOME.
# Clicking it always shows the Firefox profile manager, regardless of
# whether another Firefox instance is already running.
#
# This is fully self-contained: it does not depend on any other script
# or file. Keep this one file in your dotfiles repo and just run it.
#
# --no-remote is required: without it, if a Firefox instance is already
# running, the -P command gets forwarded to it and silently ignored
# (you'd just see the existing window instead of the profile picker).
# --no-remote also ensures the profile you pick runs as a truly separate
# instance, which is what lets you run two profiles side by side.
#
# Safe to re-run (overwrites its own previous output, doesn't touch
# Firefox's real .desktop file at all).

set -euo pipefail

APP_ID="firefox-profile-picker"
APP_NAME="Firefox Profile Picker"
APP_ICON="firefox-esr"
APP_EXEC="firefox -P --no-remote"

USER_APPS_DIR="${HOME}/.local/share/applications"
DESKTOP_FILE="${USER_APPS_DIR}/${APP_ID}.desktop"

mkdir -p "$USER_APPS_DIR"

cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Type=Application
Name=${APP_NAME}
Comment=Open the Firefox profile manager to choose or run a profile
Exec=${APP_EXEC}
Icon=${APP_ICON}
Terminal=false
Categories=Network;WebBrowser;
StartupNotify=true
EOF

echo "Wrote desktop entry: $DESKTOP_FILE"

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$USER_APPS_DIR"
    echo "Refreshed desktop database."
else
    echo "Note: update-desktop-database not found; you may need to log out/in for the app to appear." >&2
fi

echo "Done. Search for '${APP_NAME}' in GNOME's app grid/Activities overview."
