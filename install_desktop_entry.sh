#!/usr/bin/env bash
set -euo pipefail

APP_ID="markdown-mermaid-to-images"
APP_NAME="Markdown Mermaid to Images"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_BIN="$PROJECT_ROOT/dist/$APP_ID"

# Install locations (user-local)
BIN_DIR="$HOME/.local/bin"
BIN_PATH="$BIN_DIR/$APP_ID"
DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/${APP_ID}.desktop"

# 1) Ensure built binary exists
if [ ! -x "$DIST_BIN" ]; then
  echo "ERROR: Built binary not found at: $DIST_BIN"
  echo "Run ./build_pyinstaller.sh first."
  exit 1
fi

# 2) Install binary
mkdir -p "$BIN_DIR"
cp "$DIST_BIN" "$BIN_PATH"
chmod 755 "$BIN_PATH"

# Ensure ~/.local/bin is on PATH (future shells)
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  echo "Added ~/.local/bin to PATH in ~/.bashrc (restart your shell to pick it up)."
fi

# 3) Create .desktop file
mkdir -p "$DESKTOP_DIR"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=$APP_NAME
Comment=Convert Mermaid diagrams in Markdown to image files
Exec=$BIN_PATH %F
Icon=$PROJECT_ROOT/assets/markdown-mermaid-to-images.png
Terminal=true
Categories=Development;Utility;
EOF

# 4) Update desktop DB if tool exists
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$DESKTOP_DIR" || true
fi

echo "Installed binary to: $BIN_PATH"
echo "Created desktop entry: $DESKTOP_FILE"
echo "You should now see \"$APP_NAME\" in your application menu."
