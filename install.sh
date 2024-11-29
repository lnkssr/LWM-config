#!/bin/bash

# Выход из скрипта при ошибке
set -e

# Проверка, чтобы скрипт запускался не от root
if [ "$EUID" -eq 0 ]; then
  echo "Не запускайте этот скрипт от root!"
  exit 1
fi

# Определение исходных и целевых директорий
SOURCE_DIR="$(pwd)"
TARGET_HOME="/home/$USER"

echo "Копирование конфигураций из $SOURCE_DIR в $TARGET_HOME..."
echo "Убедитесь, что вы сохранили свои текущие настройки, если это необходимо."

# Создание недостающих папок
mkdir -p "$TARGET_HOME/.config"
mkdir -p "$TARGET_HOME/.themes"

# Функция для копирования директорий
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

# Копируем домашние файлы
copy_dir "$SOURCE_DIR/home" "$TARGET_HOME"

# Копируем конфигурационные файлы
copy_dir "$SOURCE_DIR/.config" "$TARGET_HOME/.config"

# Копируем темы
copy_dir "$SOURCE_DIR/.themes" "$TARGET_HOME/.themes"

# Обновление пути в файле config.rasi
ROFI_CONFIG="$TARGET_HOME/.config/rofi/config.rasi"
if [ -f "$ROFI_CONFIG" ]; then
  echo "Обновление пути в $ROFI_CONFIG..."
  sed -i "s|/home/f1la|$TARGET_HOME|g" "$ROFI_CONFIG"
else
  echo "Файл $ROFI_CONFIG не найден. Пропуск."
fi

echo "Установка завершена. Проверьте, все ли данные скопированы корректно."
