# Engine Decision — Boomer Shooter "Cthulhu Boltgun"

## Resumen Ejecutivo

**Recomendación: Godot 4.x con módulo de raycasting custom**

Para un boomer shooter estilo Wolfenstein 3D + Boltgun con estética Lovecraftiana, Godot 4.x ofrece el mejor balance entre:
- Control total del pipeline de renderizado retro
- Facilidad para sprites 2D en mundo 3D (billboarding)
- Iteración rápida y prototipado
- Licencia MIT (sin royalties)

---

## Opciones Evaluadas

### 1. Godot 4.x ⭐ RECOMENDADO

**Pros:**
- **Raycasting nativo**: PhysicsServer3D permite raycasts eficientes para el renderizado estilo Wolfenstein
- **Control de renderizado**: Viewport con resolución fija + upscale para pixel perfect
- **Sprites 3D**: Sprite3D y AnimatedSprite3D con billboarding automático
- **Shaders retro**: Fácil implementar efectos de paleta limitada, dithering, posterización
- **GDScript/C#**: Iteración rápida, buen performance para este estilo
- **Exportación**: Windows, Linux, Mac, Web, consolas (con terceros)

**Contras:**
- Curva de aprendizaje si el equipo no conoce Godot
- Menos "industry standard" que Unity/Unreal para portfolios

**Fit para este proyecto: 9/10**

---

### 2. Unity 2022 LTS

**Pros:**
- Asset Store enorme
- C# es productivo
- Mucha documentación y tutoriales

**Contras:**
- **Overkill**: Mucha complejidad innecesaria para un raycaster
- **Render pipeline**: URP/HDRP no están pensados para renderizado retro custom
- **Licencia**: Runtime fee controversial (aunque revertido parcialmente)
- **Pesado**: Editor lento, builds grandes

**Fit para este proyecto: 5/10**

---

### 3. Unreal Engine 5

**Pros:**
- Gráficos AAA "gratis"
- Blueprints para prototipado rápido

**Contras:**
- **Totalmente overkill**: Nanite, Lumen, etc. no aplican a un boomer shooter
- **Peso**: 100GB+ de instalación, builds de 2GB+
- **Curva**: C++ o Blueprints complejos para algo que debería ser simple
- **Estética**: Difícil lograr el look "pixel art auténtico" sin luchar contra el engine

**Fit para este proyecto: 3/10**

---

### 4. Framework Custom (C++/Rust + raycasting)

**Pros:**
- Control absoluto
- Performance máximo
- Aprendizaje profundo de gráficos

**Contras:**
- **Tiempo**: 6-12 meses solo para el engine
- **Riesgo**: Bugs de bajo nivel, tooling inexistente
- **Scope creep**: Fácil perderse en features del engine vs. el juego

**Fit para este proyecto: 4/10** (solo si el objetivo es aprender, no shippear)

---

### 5. GZDoom / ECWolf (source ports)

**Pros:**
- Engine probado, optimizado
- Comunidad enorme de mods
- Formatos estándar (WAD, PK3)

**Contras:**
- **Limitaciones**: Herencia de 30 años de código
- **No es tu juego**: Es un mod de Doom, no un juego standalone
- **Monetización**: Complicada (GPL para GZDoom)

**Fit para este proyecto: 6/10** (bueno para prototipo, malo para producto final)

---

## Arquitectura Recomendada en Godot 4

```
Game (Node)
├── World (Node3D)
│   ├── Level (GridMap + custom raycast renderer)
│   ├── Player (CharacterBody3D + FPS controller)
│   ├── Enemies (Node3D con Sprite3D billboards)
│   └── Pickups (Area3D + Sprite3D)
├── UI (CanvasLayer)
│   ├── HUD (Control)
│   └── Menus (Control)
└── Systems (Autoloads)
    ├── GameState (roguelike run manager)
    ├── MetaProgression (desbloqueos persistentes)
    └── AudioManager
```

### Renderizado Retro

**Viewport principal:**
- Resolución interna: 320x200 o 640x400
- Upscale: 4x-6x con nearest neighbor
- Paleta limitada: shader que reduce a 16-32 colores
- Dithering: Bayer 4x4 o blue noise

**Raycasting custom:**
- Grid-based: mapa 2D de tiles
- DDA algorithm para paredes
- Z-buffer para sprites (ordenar por distancia)
- Texturas: 64x64 o 128x128, filtrado point

---

## Stack Tecnológico Final

| Componente | Tecnología |
|------------|-----------|
| Engine | Godot 4.2+ |
| Lenguaje | GDScript (prototipo), C# (optimización si necesario) |
| Renderizado | Custom raycaster + Viewport upscale |
| Sprites | Aseprite (pixel art), export PNG |
| Audio | Audacity (edición), Godot AudioStream |
| Control de versiones | Git + GitHub/GitLab |
| CI/CD | GitHub Actions (export automático) |

---

## Próximos Pasos

1. **Prototipo**: Implementar raycaster básico en Godot (2-3 días)
2. **Validación**: Confirmar que el feel es correcto (movimiento, disparo)
3. **Pipeline**: Establecer workflow de sprites y niveles
4. **Vertical slice**: Un nivel completo con 3 enemigos, 2 armas

---

## Referencias

- [Godot 4 Docs — 3D Rendering](https://docs.godotengine.org/en/stable/tutorials/3d/index.html)
- [Boltgun — Análisis de estilo](https://www.youtube.com/watch?v=example)
- [Lovecraftian Game Design](https://www.gamedeveloper.com/design/lovecraftian-horror-in-games)

---

*Documento generado por Iria Devon — 2026-10-08*
