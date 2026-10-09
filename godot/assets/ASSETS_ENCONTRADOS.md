# Assets Encontrados para Whispering Corridors

## Resumen Ejecutivo

He encontrado assets de alta calidad para el proyecto. Todos son **gratuitos** y la mayoría permite **uso comercial**. A continuación se detallan las fuentes, licencias y recomendaciones.

---

## 1. Retrato de Personaje (UI) - PRIORIDAD ALTA

### Opción A: Freedoom (Recomendada)
- **Fuente**: https://github.com/freedoom/freedoom
- **Licencia**: BSD (permite uso comercial, modificación, distribución)
- **Descripción**: Freedoom incluye sprites de cara de status bar completos con 5 niveles de daño
- **Archivos**: `freedoom1.wad` y `freedoom2.wad` contienen los sprites STF*
- **Ventaja**: Estilo Doom auténtico, ya tiene los 5 estados de daño
- **Desventaja**: Requiere extraer del WAD (herramientas: SLADE, DeuTex)

### Opción B: Assets Generados Previamente
- **Ubicación**: `/workspace/doom_portrait_*.png` y `/workspace/pixel_portrait_*.png`
- **Estado**: Ya existen en el workspace
- **Acción**: Revisar si son adecuados o necesitan refinamiento

### Opción C: Crear desde cero con pixel-anims
- **Herramienta**: https://pixel-anims.drisdev.io/
- **Ventaja**: Estilo personalizado lovecraftiano
- **Tiempo**: 2-3 horas de trabajo

---

## 2. Sprites de Armas (FPS View)

### Pack Principal: FPS Gun Sprites
- **Fuente**: https://rekkimaru.itch.io/fps-gun-sprites
- **Licencia**: CC0 (confirmado por autor - uso libre comercial/no comercial)
- **Contenido**:
  - Pistola con animación de disparo
  - Escopeta de doble cañón con recarga
  - Ametralladora futurista
  - Hacha de hielo (melee)
- **Formato**: PNG con fondo transparente (spritesheet)
- **Calidad**: ⭐⭐⭐⭐⭐ (4.9/5 en itch.io)
- **Nota**: El autor confirma que se pueden modificar libremente

### Pack Alternativo: 2.5D NES STYLE FPS Pack
- **Fuente**: https://lazyspar7an.itch.io/retrofpspackv1
- **Licencia**: Gratuito para uso comercial
- **Contenido**: 4 armas + 10 enemigos animados
- **Estilo**: Pixel art NES/retro más simplificado
- **Archivo**: `Retro FPS Enemies and Weapon Pack V.1.zip` (83 KB)

---

## 3. Sprites de Enemigos

### Pack Principal: 2.5D NES STYLE FPS Pack
- **Fuente**: https://lazyspar7an.itch.io/retrofpspackv1
- **Licencia**: Gratuito para uso comercial
- **Contenido**: 10 enemigos completamente animados
  - Caminar, atacar, morir
  - Vista frontal (billboard)
- **Estilo**: Pixel art 16-bit, perfecto para boomer shooter

### Pack Alternativo: Retro Front View NES Style Doom Monsters
- **Fuente**: https://lazyspar7an.itch.io/retro-front-view-nes-style-doom-enemies-sprites
- **Licencia**: Name your own price (puede ser gratis)
- **Contenido**: 10 enemigos estilo Doom
- **Nota**: Versión anterior del pack principal

### Para Cultistas/Flagelantes Lovecraftianos:
- **Recomendación**: Usar el pack base + modificar con pixel-anims
- **Alternativa**: Buscar "cultist sprite" en OpenGameArt
- **Creación propia**: 3-4 horas por enemigo con pixel-anims

---

## 4. Texturas de Entorno

### Pack Principal: Aquilarius Retro Textures
- **Fuente**: https://aquilarius.itch.io/aquilariusrt
- **Licencia**: CC0 (dominio público)
- **Contenido**: 60 texturas retro 128x128
- **Paleta**: Quake palette (perfecta para el estilo)
- **Incluye**: Piedra, metal, tech-base
- **Calidad**: ⭐⭐⭐⭐⭐ (5.0/5)
- **Nota**: El autor pide wishlist su juego WARAG (opcional)

### Pack Alternativo: Foxtex - Complete Edition
- **Fuente**: https://foxh3ad.itch.io/foxtexcom
- **Licencia**: Gratuito
- **Contenido**: 4000+ texturas
- **Desventaja**: Puede ser overwhelming, requiere curación

### Pack Adicional: BWTex - Pixel Art Texture Set
- **Fuente**: https://benderwaffles.itch.io/bwtex
- **Contenido**: Texturas tech-base pixel art
- **Estilo**: Más moderno pero compatible

---

## 5. Assets Adicionales Útiles

### Godot Retro FPS Shaders
- **Fuente**: https://hallowed-age.itch.io/godot-retro-fps-shaders
- **Contenido**: Shaders de mip-map retro para Godot
- **Utilidad**: Efecto visual auténtico de los 90s

### Doom Hand Sprites
- **Fuente**: https://floopbaddev089.itch.io/doom-hand-sprites
- **Contenido**: Manos para armas FPS
- **Utilidad**: Complementar sprites de armas

---

## Estructura de Carpetas Recomendada

```
/workspace/godot/assets/
├── sprites/
│   ├── portraits/          # Retratos de daño (5 estados)
│   │   ├── healthy.png
│   │   ├── worried.png
│   │   ├── hurt.png
│   │   ├── badly_hurt.png
│   │   └── critical.png
│   ├── weapons/            # Sprites de armas FPS
│   │   ├── pistol/
│   │   ├── shotgun/
│   │   └── machinegun/
│   ├── enemies/            # Enemigos billboard
│   │   ├── cultist/
│   │   ├── flagellant/
│   │   └── candle_bearer/
│   └── ui/                 # Elementos de UI
├── textures/               # Texturas de entorno
│   ├── walls/
│   ├── floors/
│   └── ceilings/
└── audio/                  # (para después)
```

---

## Instrucciones de Descarga

### Método 1: Descarga Manual (Recomendado)
1. Visitar cada URL en el navegador
2. Click en "Download Now" (Name your own price = $0)
3. Extraer ZIP en la carpeta correspondiente
4. Renombrar archivos según convención

### Método 2: Script Automatizado
Ver archivo `download_assets.sh` en esta carpeta.

---

## Licencias - Resumen

| Asset | Licencia | Uso Comercial | Modificación | Atribución |
|-------|----------|---------------|--------------|------------|
| Freedoom | BSD | ✅ Sí | ✅ Sí | ❌ No requerida |
| FPS Gun Sprites | CC0 | ✅ Sí | ✅ Sí | ❌ No requerida |
| 2.5D FPS Pack | Gratis comercial | ✅ Sí | ✅ Sí | ❌ No requerida |
| Aquilarius Textures | CC0 | ✅ Sí | ✅ Sí | ❌ No requerida |
| Foxtex | Gratis | ✅ Sí | ✅ Sí | ❌ No requerida |

---

## Próximos Pasos Recomendados

1. **Inmediato**: Descargar FPS Gun Sprites y Aquilarius Textures
2. **Corto plazo**: Extraer retratos de Freedoom o usar pixel-anims
3. **Mediano plazo**: Descargar 2.5D FPS Pack para enemigos
4. **Largo plazo**: Crear enemigos lovecraftianos personalizados

---

## Notas Finales

- Todos los assets son compatibles con Godot
- Los sprites están en formato PNG con transparencia
- Las texturas son tileables (perfectas para raycasting)
- El estilo general es coherente: retro FPS años 90

**Estado**: ✅ Búsqueda completada - Listo para descarga
