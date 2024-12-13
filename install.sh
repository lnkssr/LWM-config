#!/bin/sh

set -e

if [ "$EUID" -eq 0 ]; then
  echo "Не запускайте этот скрипт от root!"
  exit 1
fi

SOURCE_DIR="$(pwd)"
TARGET_HOME="/home/$USER"

echo "Копирование конфигураций из $SOURCE_DIR в $TARGET_HOME..."
echo "Убедитесь, что вы сохранили свои текущие настройки, если это необходимо."

mkdir -p "$TARGET_HOME/.config"
mkdir -p "$TARGET_HOME/.themes"

copy_dir() {
  local src="$1"
  local dest="$2"
  if [ -d "$src" ]; then
    echo "Копирование $src в $dest..."
    cp -r "$src"/* "$dest/"
  else
    echo "Пропущено: $src не найдено."
  fi
}

copy_dir "$SOURCE_DIR/home" "$TARGET_HOME"
copy_dir "$SOURCE_DIR/.config" "$TARGET_HOME/.config"
copy_dir "$SOURCE_DIR/.themes" "$TARGET_HOME/.themes"

# Обновление конфигурации rofi
ROFI_CONFIG="$TARGET_HOME/.config/rofi/config.rasi"
if [ -f "$ROFI_CONFIG" ]; then
  echo "Обновление пути в $ROFI_CONFIG..."
  sed -i "s|/home/f1la|$TARGET_HOME|g" "$ROFI_CONFIG"
else
  echo "Файл $ROFI_CONFIG не найден. Пропуск."
fi

# Пересоздание симлинка current
THEMES_DIR="$TARGET_HOME/.config/leftwm/themes"
CURRENT_LINK="$THEMES_DIR/current"
if [ -d "$THEMES_DIR/Ascent" ]; then
  echo "Пересоздание симлинка current на Ascent..."
  rm -f "$CURRENT_LINK"
  ln -s "$THEMES_DIR/Ascent" "$CURRENT_LINK"
else
  echo "Папка Ascent не найдена, симлинк current не был пересоздан."
fi

echo "Установка завершена. Проверьте, все ли данные скопированы корректно."
