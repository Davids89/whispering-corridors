#!/bin/bash
# Script de descarga de assets para Whispering Corridors
# Ejecutar desde la raíz del proyecto

set -e

ASSETS_DIR="/workspace/godot/assets"
SPRITES_DIR="$ASSETS_DIR/sprites"
TEXTURES_DIR="$ASSETS_DIR/textures"

echo "🎮 Descargando assets para Whispering Corridors..."
echo ""

# Crear directorios si no existen
mkdir -p "$SPRITES_DIR/portraits"
mkdir -p "$SPRITES_DIR/weapons"
mkdir -p "$SPRITES_DIR/enemies"
mkdir -p "$TEXTURES_DIR/walls"
mkdir -p "$TEXTURES_DIR/floors"
mkdir -p "$TEXTURES_DIR/ceilings"

# Función para descargar con curl
download_file() {
    local url=$1
    local output=$2
    local name=$3

    echo "⬇️  Descargando: $name"
    if curl -L -o "$output" "$url" 2>/dev/null; then
        echo "✅ Descargado: $output"
    else
        echo "❌ Error descargando: $name"
        echo "   URL: $url"
        echo "   Descargar manualmente desde el navegador"
    fi
    echo ""
}

echo "📦 NOTA IMPORTANTE:"
echo "   Los assets de itch.io requieren descarga manual desde el navegador"
echo "   debido a su sistema de 'Name your own price'."
echo ""
echo "   Por favor, visita las siguientes URLs y descarga los archivos:"
echo ""

echo "🔫 ARMAS (FPS Gun Sprites):"
echo "   URL: https://rekkimaru.itch.io/fps-gun-sprites"
echo "   Archivo: Gun Sprites.zip (464 KB)"
echo "   Destino: $SPRITES_DIR/weapons/"
echo ""

echo "👾 ENEMIGOS (2.5D NES STYLE FPS Pack):"
echo "   URL: https://lazyspar7an.itch.io/retrofpspackv1"
echo "   Archivo: Retro FPS Enemies and Weapon Pack V.1.zip (83 KB)"
echo "   Destino: $SPRITES_DIR/enemies/"
echo ""

echo "🧱 TEXTURAS (Aquilarius Retro Textures):"
echo "   URL: https://aquilarius.itch.io/aquilariusrt"
echo "   Archivo: AquilariusRetroTextures.zip (2.9 MB)"
echo "   Destino: $TEXTURES_DIR/"
echo ""

echo "😀 RETRATOS (Freedoom):"
echo "   URL: https://github.com/freedoom/freedoom/releases"
echo "   Archivo: freedoom-0.13.0.zip"
echo "   Nota: Extraer sprites STF* del WAD con SLADE"
echo "   Destino: $SPRITES_DIR/portraits/"
echo ""

# Intentar descargar Freedoom (este sí permite descarga directa)
echo "🔄 Intentando descargar Freedoom (puede tardar)..."
FREEDOOM_URL="https://github.com/freedoom/freedoom/releases/download/v0.13.0/freedoom-0.13.0.zip"
if curl -L -o "/tmp/freedoom.zip" "$FREEDOOM_URL" 2>/dev/null; then
    echo "✅ Freedoom descargado a /tmp/freedoom.zip"
    echo "   Extraer con: unzip /tmp/freedoom.zip -d /tmp/freedoom"
    echo "   Luego usar SLADE para extraer sprites STF* de freedoom2.wad"
else
    echo "⚠️  Descarga automática de Freedoom falló"
    echo "   Descargar manualmente desde: https://github.com/freedoom/freedoom/releases"
fi

echo ""
echo "📋 RESUMEN DE LICENCIAS:"
echo "   ✅ Freedoom: BSD (uso comercial OK)"
echo "   ✅ FPS Gun Sprites: CC0 (uso libre)"
echo "   ✅ 2.5D FPS Pack: Gratis comercial"
echo "   ✅ Aquilarius Textures: CC0 (dominio público)"
echo ""

echo "🎯 PRÓXIMOS PASOS:"
echo "   1. Descargar los assets manualmente desde itch.io"
echo "   2. Extraer los ZIP en las carpetas correspondientes"
echo "   3. Para Freedoom: usar SLADE para extraer sprites STF*"
echo "   4. Renombrar archivos según convención del proyecto"
echo ""

echo "✨ Script completado"
