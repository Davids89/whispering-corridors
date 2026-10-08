#!/bin/bash
# ============================================
# WHISPERING CORRIDORS — Deploy a GitHub
# ============================================
# Ejecutar: bash deploy-to-github.sh
# ============================================

set -e

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║     WHISPERING CORRIDORS — Deploy a GitHub Pages          ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificar git
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git no está instalado${NC}"
    exit 1
fi

# Verificar si ya es un repo git
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Inicializando repositorio git...${NC}"
    git init
    git config user.email "david@teros.ai"
    git config user.name "David Luque"
fi

# Añadir archivos
echo -e "${YELLOW}Añadiendo archivos...${NC}"
git add -A

# Commit
echo -e "${YELLOW}Creando commit...${NC}"
git commit -m "Whispering Corridors v0.1.0 — Boomer shooter lovecraftiano

- GDD completo con sistema roguelike
- Prototipo raycasting HTML5 jugable  
- Sistema de armas (8 tipos) y enemigos (8 tipos + elites)
- Diseño de nivel 1: El Asilo
- Diseño de UI/HUD y audio
- Sprites prototipo
- Documentación técnica completa

Inspiración: Lovecraft + Warhammer 40K Boltgun" || echo "Commit ya existe o no hay cambios"

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  PASO 1: Crear repositorio en GitHub                      ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "1. Abre: https://github.com/new"
echo "2. Repository name: whispering-corridors"
echo "3. Description: Boomer shooter lovecraftiano con elementos roguelike"
echo "4. Public (necesario para GitHub Pages gratis)"
echo "5. NO marques 'Add a README file'"
echo "6. Click 'Create repository'"
echo ""
read -p "Presiona ENTER cuando hayas creado el repositorio..."

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  PASO 2: Conectar y subir                                 ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
read -p "Pega la URL del repositorio (ej: https://github.com/tuusuario/whispering-corridors.git): " REPO_URL

if [ -z "$REPO_URL" ]; then
    echo -e "${RED}Error: URL vacía${NC}"
    exit 1
fi

# Configurar remoto
echo -e "${YELLOW}Configurando remoto...${NC}"
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

# Renombrar a main
git branch -M main 2>/dev/null || true

# Subir
echo -e "${YELLOW}Subiendo a GitHub...${NC}"
git push -u origin main

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ¡CÓDIGO SUBIDO CON ÉXITO!                    ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Extraer usuario y repo
if [[ $REPO_URL =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    USERNAME="${BASH_REMATCH[1]}"
    REPONAME="${BASH_REMATCH[2]}"
    
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  PASO 3: Activar GitHub Pages                             ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "1. Ve a: https://github.com/${USERNAME}/${REPONAME}/settings/pages"
    echo "2. En 'Source', selecciona: Deploy from a branch"
    echo "3. En 'Branch', selecciona: main"
    echo "4. En 'Folder', selecciona: / (root)"
    echo "5. Click 'Save'"
    echo ""
    echo -e "${GREEN}Tu prototipo estará en:${NC}"
    echo -e "${YELLOW}https://${USERNAME}.github.io/${REPONAME}/prototype/index.html${NC}"
    echo ""
    echo -e "${BLUE}Nota:${NC} GitHub Pages puede tardar 1-2 minutos en activarse"
    echo ""
    
    # Abrir automáticamente si es posible
    if command -v open &> /dev/null; then
        read -p "¿Abrir la página de configuración ahora? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            open "https://github.com/${USERNAME}/${REPONAME}/settings/pages"
        fi
    elif command -v xdg-open &> /dev/null; then
        read -p "¿Abrir la página de configuración ahora? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            xdg-open "https://github.com/${USERNAME}/${REPONAME}/settings/pages"
        fi
    fi
else
    echo -e "${YELLOW}No se pudo determinar la URL de GitHub Pages${NC}"
    echo "Ve a Settings > Pages en tu repositorio"
fi

echo ""
echo -e "${GREEN}¡Proceso completado!${NC}"
