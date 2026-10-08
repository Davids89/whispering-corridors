#!/bin/bash
# ============================================
# SCRIPT: Subir Whispering Corridors a GitHub
# ============================================
# 
# INSTRUCCIONES:
# 1. Ve a https://github.com/new
# 2. Crea un repositorio llamado: whispering-corridors
# 3. NO inicialices con README, .gitignore o licencia
# 4. Copia la URL del repositorio (ej: https://github.com/tuusuario/whispering-corridors.git)
# 5. Ejecuta este script: ./deploy-github.sh [URL_DEL_REPO]
#
# Ejemplo:
#   ./deploy-github.sh https://github.com/davidluque/whispering-corridors.git
# ============================================

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     WHISPERING CORRIDORS — Deploy a GitHub Pages          ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar argumento
if [ -z "$1" ]; then
    echo -e "${RED}Error: Debes proporcionar la URL del repositorio${NC}"
    echo ""
    echo "Uso: ./deploy-github.sh https://github.com/TU_USUARIO/whispering-corridors.git"
    echo ""
    echo "Pasos previos:"
    echo "1. Ve a https://github.com/new"
    echo "2. Nombre del repo: whispering-corridors"
    echo "3. Descripción: Boomer shooter lovecraftiano con elementos roguelike"
    echo "4. Público"
    echo "5. NO inicializar con README"
    echo "6. Crear repositorio"
    echo "7. Copiar la URL HTTPS"
    exit 1
fi

REPO_URL=$1

echo -e "${YELLOW}Configurando repositorio...${NC}"

# Verificar que estamos en el directorio correcto
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: No se encuentra el repositorio git${NC}"
    echo "Ejecuta este script desde la raíz del proyecto"
    exit 1
fi

# Añadir remoto
echo -e "${YELLOW}Añadiendo remoto origin...${NC}"
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

# Verificar rama actual
BRANCH=$(git branch --show-current)
echo -e "${YELLOW}Rama actual: ${BRANCH}${NC}"

# Renombrar a main si es necesario (GitHub Pages prefiere main)
if [ "$BRANCH" != "main" ]; then
    echo -e "${YELLOW}Renombrando rama a 'main'...${NC}"
    git branch -M main
fi

# Subir código
echo -e "${YELLOW}Subiendo código a GitHub...${NC}"
git push -u origin main

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ¡REPOSITORIO SUBIDO CON ÉXITO!               ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Extraer usuario y repo de la URL
if [[ $REPO_URL =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    USERNAME="${BASH_REMATCH[1]}"
    REPONAME="${BASH_REMATCH[2]}"
    
    echo -e "${BLUE}Configurando GitHub Pages...${NC}"
    echo ""
    echo "Para activar GitHub Pages:"
    echo "1. Ve a: https://github.com/${USERNAME}/${REPONAME}/settings/pages"
    echo "2. En 'Source', selecciona: Deploy from a branch"
    echo "3. En 'Branch', selecciona: main"
    echo "4. En 'Folder', selecciona: / (root)"
    echo "5. Click en Save"
    echo ""
    echo -e "${GREEN}Tu prototipo estará disponible en:${NC}"
    echo -e "${YELLOW}https://${USERNAME}.github.io/${REPONAME}/prototype/index.html${NC}"
    echo ""
    echo -e "${BLUE}Nota:${NC} GitHub Pages puede tardar 1-2 minutos en activarse"
else
    echo -e "${YELLOW}No se pudo extraer la URL de GitHub Pages automáticamente${NC}"
    echo "Ve a Settings > Pages en tu repositorio para activarlo"
fi

echo ""
echo -e "${GREEN}¡Listo!${NC}"
