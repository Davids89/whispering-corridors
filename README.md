# Whispering Corridors

Un **boomer shooter lovecraftiano** con elementos roguelike, inspirado en H.P. Lovecraft y Warhammer 40K: Boltgun.

![Estado](https://img.shields.io/badge/estado-vertical%20slice-orange)
![Engine](https://img.shields.io/badge/engine-Godot%204.2-blue)
![Licencia](https://img.shields.io/badge/licencia-MIT-green)

## 🎮 Proyecto Godot 4

Este repositorio contiene el **vertical slice** de Whispering Corridors desarrollado en **Godot 4**.

### Características del Vertical Slice

- 🔫 **3 armas** — Pistola del Culto, Escopeta Ritual, Ametralladora
- 👹 **3 enemigos** — Cultista, Flagelante, Portador de Vela
- 🏚️ **1 zona completa** — El Asilo (6 salas + boss)
- 👑 **1 boss** — El Guardián del Asilo (2 fases)
- 🎨 **Renderizado raycasting** — Estilo Wolfenstein 3D

## 📁 Estructura del Proyecto

```
whispering-corridors/
├── godot/                    # Proyecto Godot 4
│   ├── project.godot        # Configuración del proyecto
│   ├── icon.svg             # Icono del juego
│   ├── scenes/              # Escenas
│   │   ├── main/           # Escena principal
│   │   ├── player/         # Jugador
│   │   ├── enemies/        # Enemigos
│   │   ├── weapons/        # Armas
│   │   ├── levels/         # Niveles
│   │   ├── ui/             # Interfaz
│   │   └── effects/        # Efectos
│   ├── scripts/             # Scripts GDScript
│   │   ├── autoload/       # Singletons (GameManager, etc.)
│   │   ├── components/     # Componentes reutilizables
│   │   └── systems/        # Sistemas del juego
│   ├── assets/              # Recursos
│   │   ├── sprites/        # Sprites y texturas
│   │   ├── audio/          # Música y SFX
│   │   ├── fonts/          # Fuentes
│   │   └── shaders/        # Shaders personalizados
│   └── resources/           # Recursos de Godot
│       ├── tilesets/       # Tilesets para niveles
│       └── themes/         # Temas de UI
├── docs/                    # Documentación de diseño
│   ├── GDD.md              # Game Design Document
│   ├── roguelike-system.md # Sistema roguelike
│   ├── level-generation.md # Generación procedural
│   ├── engine-decision.md  # Decisión de motor
│   └── audio-design.md     # Diseño de audio
├── design/                  # Diseño de niveles y UI
│   ├── level-01.md         # El Asilo
│   └── ui-design.md        # Diseño de interfaz
└── prototype/               # Prototipo HTML5 (legacy)
    └── index.html          # Demo raycasting original
```

## 🚀 Cómo Ejecutar

### Requisitos
- **Godot 4.2+** (descargar de https://godotengine.org/download)

### Pasos
1. Clonar el repositorio:
   ```bash
   git clone https://github.com/Davids89/whispering-corridors.git
   cd whispering-corridors
   ```

2. Abrir Godot 4

3. Importar proyecto:
   - Click en "Import"
   - Seleccionar `godot/project.godot`
   - Click "Import & Edit"

4. Ejecutar:
   - Presiona `F5` o click en el botón Play
   - La escena principal es `scenes/main/Main.tscn`

## 🎯 Controles

| Tecla | Acción |
|-------|--------|
| `WASD` | Movimiento |
| `Ratón` | Mirar |
| `Click` | Disparar |
| `R` | Recargar |
| `1-3` | Cambiar arma |
| `E` | Interactuar |
| `ESC` | Pausa / Liberar mouse |
| `F3` | Debug info |

## 📚 Documentación

- [GDD Completo](docs/GDD.md)
- [Sistema Roguelike](docs/roguelike-system.md)
- [Generación Procedural](docs/level-generation.md)
- [Diseño de Audio](docs/audio-design.md)
- [Diseño de UI](design/ui-design.md)
- [Nivel 1: El Asilo](design/level-01.md)

## 🗺️ Roadmap

- [x] Documentación de diseño completa
- [x] Prototipo HTML5 (validación de concepto)
- [x] Setup Godot 4
- [ ] Sistema de renderizado raycasting
- [ ] Controlador de jugador
- [ ] Sistema de armas (3 armas)
- [ ] Sistema de enemigos (3 enemigos + IA)
- [ ] Nivel 1: El Asilo
- [ ] Boss: El Guardián del Asilo
- [ ] Sistema de UI/HUD
- [ ] Vertical slice completo

## 🛠️ Tecnologías

- **Engine**: Godot 4.2+
- **Lenguaje**: GDScript
- **Arte**: Pixel art, Aseprite
- **Audio**: Dark ambient, industrial
- **Control de versiones**: Git

## 🤝 Contribuir

Este es un proyecto personal, pero sugerencias y feedback son bienvenidos. Abre un issue para reportar bugs o proponer ideas.

## 📄 Licencia

MIT License — ver [LICENSE](LICENSE) para más detalles.

---

*"El vacío no es vacío. Está lleno de susurros."*
