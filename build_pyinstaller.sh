#!/usr/bin/env bash
set -euo pipefail

# Change these if you like
VENV_DIR=".venv"
APP_NAME="markdown-mermaid-to-images"
ENTRY_SCRIPT="$VENV_DIR/bin/markdown_mermaid_to_images"

# 1) Create venv if needed
if [ ! -d "$VENV_DIR" ]; then
  python3 -m venv "$VENV_DIR"
fi

# 2) Activate venv
source "$VENV_DIR/bin/activate"

# 3) Install dependencies and PyInstaller
pip install --upgrade pip
pip install -r requirements.txt
pip install .      # install the package so the console script is created
pip install pyinstaller

# 4) Sanity check
if ! command -v markdown_mermaid_to_images >/dev/null 2>&1; then
  echo "ERROR: markdown_mermaid_to_images entry point not found in venv."
  exit 1
fi

# 5) Build single-file executable
pyinstaller \
  --clean \
  --onefile \
  --name markdown-mermaid-to-images \
  --add-data "puppeteer.json:." \
  --hidden-import platformdirs \
  --collect-all platformdirs \
  "$ENTRY_SCRIPT"

echo
echo "Build complete. Executable is at dist/$APP_NAME"

echo "Create soft link for easy access:"
echo "ln -sf \$(pwd)/dist/$APP_NAME ~/bin/"
ln -sf "$(pwd)/dist/$APP_NAME" ~/bin/
