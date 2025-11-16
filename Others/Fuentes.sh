#!/usr/bin/env bash
# ========================================================
# Script: install_fonts_pack.sh
# Autor: Nicolás (Infraestructura Debian 13 XFCE)
# Descripción: Instala fuentes comunes, Nerd Fonts e íconos
# ========================================================

set -euo pipefail

# === Comprobación de dependencias básicas ===
for cmd in wget unzip fc-cache; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "⚠️  Instalando dependencia requerida: $cmd"
        sudo apt install -y "$cmd"
    fi
done

echo "=== Instalando fuentes básicas del sistema ==="
sudo apt update -y
sudo apt install -y \
  fonts-dejavu \
  fonts-liberation \
  fonts-noto \
  fonts-noto-cjk \
  fonts-noto-color-emoji \
  fonts-freefont-ttf \
  fonts-cantarell \
  fonts-droid-fallback \
  fonts-ubuntu \
  fonts-roboto \
  fonts-firacode \
  fonts-hack-ttf \
  fonts-jetbrains-mono \
  fonts-inconsolata \
  fonts-font-awesome \
  fonts-material-design-icons-iconfont \
  fonts-lato \
  fonts-open-sans \
  fonts-powerline

echo "=== Instalando fuentes de Microsoft (EULA) ==="
sudo apt install -y ttf-mscorefonts-installer || echo "⚠️  Paquete no disponible, revisa los repositorios 'contrib' habilitados."

echo "=== Descargando Nerd Fonts populares ==="
FONT_DIR="$HOME/.local/share/fonts/nerdfonts"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"

NERD_FONTS=("FiraCode" "JetBrainsMono" "Hack" "Iosevka" "CascadiaCode")

for font in "${NERD_FONTS[@]}"; do
  ZIP="${font}.zip"
  URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${ZIP}"
  echo "→ Instalando ${font} Nerd Font..."
  if wget -q --show-progress "$URL"; then
      unzip -o -q "$ZIP"
      rm -f "$ZIP"
  else
      echo "❌ No se pudo descargar ${font}."
  fi
done

echo "=== Actualizando caché de fuentes ==="
fc-cache -fv > /dev/null

echo "=== Verificación rápida de instalación ==="
fc-list | grep -Ei 'fira|jetbrains|hack|noto|ubuntu|roboto' | head -n 10 || echo "⚠️  No se encontraron fuentes para mostrar."

echo "✅ Instalación de fuentes completada correctamente."
