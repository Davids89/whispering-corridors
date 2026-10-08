# Whispering Corridors

Un **boomer shooter lovecraftiano** con elementos roguelike, inspirado en H.P. Lovecraft y Warhammer 40K: Boltgun.

![Estado](https://img.shields.io/badge/estado-prototipo-orange)
![Engine](https://img.shields.io/badge/engine-HTML5%20Canvas-blue)
![Licencia](https://img.shields.io/badge/licencia-MIT-green)

## 🎮 Demo Jugable

**[▶️ Jugar Prototipo](https://davids89.github.io/whispering-corridors/prototype/index.html)**

Controles:
- `WASD` — Movimiento
- `Ratón` — Mirar
- `Click` — Disparar
- `1-4` — Cambiar arma
- `R` — Recargar

## 📖 Sobre el Proyecto

**Whispering Corridors** es un shooter de acción frenética ambientado en un universo de horror cósmico. Encarnas a un **Inquisidor del Vacío**, cazando cultistas en instalaciones poseídas por entidades dimensionales.

### Características

- 🔫 **8 armas únicas** — desde la Pistola del Culto hasta La Última Palabra
- 👹 **8+ tipos de enemigos** — cultistas, híbridos, horrores dimensionales
- 🎲 **Sistema roguelike** — runs procedurales, muerte permanente, meta-progresión
- 🏚️ **3 zonas temáticas** — El Asilo, La Instalación, El Umbral
- 🎨 **Estética retro** — pixel art, paleta lovecraftiana, renderizado raycasting

## 📁 Estructura del Proyecto

```
whispering-corridors/
├── prototype/           # Prototipo jugable HTML5
│   └── index.html      # Demo raycasting
├── src/
│   ├── weapons/        # Sistema de armas
│   │   └── weapons.js
│   └── enemies/        # Sistema de enemigos e IA
│       └── enemies.js
├── docs/               # Documentación de diseño
│   ├── GDD.md          # Game Design Document
│   ├── roguelike-system.md
│   ├── level-generation.md
│   ├── engine-decision.md
│   └── audio-design.md
├── design/             # Diseño de niveles y UI
│   ├── level-01.md     # El Asilo
│   └── ui-design.md
└── assets/             # Sprites y recursos
    └── sprites/
        └── prototypes/ # Prototipos animados
```

## 🎯 Roadmap

- [x] Documentación de diseño completa
- [x] Prototipo de renderizado raycasting
- [x] Sistemas de armas y enemigos (código)
- [x] Diseño de nivel 1
- [ ] Implementación en Godot 4
- [ ] Sprites finales
- [ ] Audio y música
- [ ] Vertical slice jugable
- [ ] Early Access

## 🛠️ Tecnologías

- **Prototipo**: HTML5 Canvas, JavaScript vanilla
- **Engine objetivo**: Godot 4.x
- **Arte**: Pixel art, Aseprite
- **Audio**: Dark ambient, industrial

## 📚 Documentación

- [GDD Completo](docs/GDD.md)
- [Sistema Roguelike](docs/roguelike-system.md)
- [Generación Procedural](docs/level-generation.md)
- [Diseño de Audio](docs/audio-design.md)
- [Diseño de UI](design/ui-design.md)

## 🤝 Contribuir

Este es un proyecto personal, pero sugerencias y feedback son bienvenidos. Abre un issue para reportar bugs o proponer ideas.

## 📄 Licencia

MIT License — ver [LICENSE](LICENSE) para más detalles.

---

*"El vacío no es vacío. Está lleno de susurros."*
