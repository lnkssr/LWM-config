#!/bin/sh

set -e

# Prevent running as root
if [ "$EUID" -eq 0 ]; then
  echo "Do not run this script as root!"
  exit 1
fi

SOURCE_DIR="$(pwd)"
TARGET_HOME="/home/$USER"

echo "Copying configuration files from $SOURCE_DIR to $TARGET_HOME..."
echo "Make sure you've backed up your current settings if needed."

mkdir -p "$TARGET_HOME/.config"
mkdir -p "$TARGET_HOME/.themes"

copy_dir() {
  local src="$1"
  local dest="$2"
  if [ -d "$src" ]; then
    echo "Copying $src to $dest..."
    cp -r "$src"/* "$dest/"
  else
    echo "Skipped: $src not found."
  fi
}

copy_dir "$SOURCE_DIR/home" "$TARGET_HOME"
copy_dir "$SOURCE_DIR/.config" "$TARGET_HOME/.config"
copy_dir "$SOURCE_DIR/.themes" "$TARGET_HOME/.themes"

# Update rofi config path
ROFI_CONFIG="$TARGET_HOME/.config/rofi/config.rasi"
if [ -f "$ROFI_CONFIG" ]; then
  echo "Updating paths in $ROFI_CONFIG..."
  sed -i "s|/home/.*|/home/$USER|g" "$ROFI_CONFIG"
else
  echo "File $ROFI_CONFIG not found. Skipping."
fi

# Recreate the 'current' symlink for leftwm theme
THEMES_DIR="$TARGET_HOME/.config/leftwm/themes"
CURRENT_LINK="$THEMES_DIR/current"
if [ -d "$THEMES_DIR/Ascent" ]; then
  echo "Recreating 'current' symlink to 'Ascent' theme..."
  rm -f "$CURRENT_LINK"
  ln -s "$THEMES_DIR/Ascent" "$CURRENT_LINK"
else
  echo "'Ascent' theme folder not found, symlink not created."
fi

# Copy polybar config
if [ -f "$SOURCE_DIR/config.ini" ]; then
  echo "Copying polybar config.ini to /etc/polybar/ (requires sudo)..."
  sudo mkdir -p /etc/polybar
  sudo cp "$SOURCE_DIR/config.ini" /etc/polybar/
else
  echo "config.ini not found in $SOURCE_DIR, skipping polybar config copy."
fi

echo "Setup complete. Please verify all configurations are applied correctly."
