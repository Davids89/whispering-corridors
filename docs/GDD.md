# GAME DESIGN DOCUMENT
## "WHISPERING CORRIDORS"
### Un Boomer Shooter Lovecraftiano con Elementos Roguelike

---

## 1. VISIÓN GENERAL

### Concepto
**Whispering Corridors** es un boomer shooter de acción frenética ambientado en un universo de horror cósmico lovecraftiano. El jugador encarna a un **Inquisidor del Vacío**, un cazador de cultistas que desciende a instalaciones poseídas por entidades dimensionales para purgar la corrupción... o sucumbir a ella.

### Inspiración Estética
| Fuente | Aportación |
|--------|-----------|
| **H.P. Lovecraft** | Mitos de Cthulhu, geometrías imposibles, locura como tema |
| **Warhammer 40K: Boltgun** | Pixel art denso, armas pesadas, violencia industrial gótica |
| **Event Horizon** | Naves/instalaciones poseídas, tecnología corrupta |
| **Dead Space** | Body horror, ambientación opresiva |
| **Bloodborne** | Arquitectura victoriana-gótica, transformación |

### Tono
- **No es cartoon**: Es brutal, opresivo, con momentos de claridad perturbadora
- **Violencia industrial**: Armas que se sienten pesadas, enemigos que gotean icor
- **Horror cósmico**: El jugador nunca entiende completamente lo que enfrenta

---

## 2. MECÁNICAS CORE

### Movimiento (Estilo Boomer Shooter)
- **Velocidad base**: 8 m/s (rápido, fluido)
- **Bunny hop**: Mantener velocidad al saltar en cadena
- **Strafe jumping**: Ganar velocidad extra con movimiento lateral + salto
- **Slide**: Opcional, deslizamiento con fricción reducida
- **Sin regeneración**: Salud y armadura solo por pickups

### Combate
- **Muchos enemigos**: Hordas de 10-30 enemigos por sala
- **Muchas balas**: Proyectiles visibles, esquivables
- **Muchas explosiones**: Daño en área, cadena de reacciones
- **Feedback visual**: Sangre pixel, partes de cuerpo, icor dimensional

### Recursos
| Recurso | Comportamiento |
|---------|---------------|
| **Salud** | No regenera. Pickups de 10/25/50. Máximo 100 (mejorable) |
| **Armadura** | Absorbe 60% de daño. Pickups de 25/50. Máximo 100 |
| **Munición** | Limitada pero generosa. 4 tipos: balas, cartuchos, cohetes, energía |
| **Almas** | Moneda meta. De enemigos elites y bosses |

---

## 3. SISTEMA ROGUELIKE

### Estructura de Runs
```
RUN
├── ZONA 1: El Asilo (4-6 salas)
│   └── BOSS: El Capellán Demente
├── ZONA 2: La Instalación (5-7 salas)
│   └── BOSS: Ingeniero Jefe Corrupto
├── ZONA 3: El Umbral (6-8 salas)
│   └── BOSS: Avatar del Vacío
└── ZONA FINAL: El Trono (1 sala)
    └── BOSS FINAL: El Que Susurra
```

### Muerte Permanente
- Pierdes: armas de la run, power-ups temporales, progreso de zona
- Mantienes: almas, desbloqueos permanentes, conocimiento (lore)

### Meta-Progresión (Entre Runs)

**Moneda Meta: ALMAS**
- Ganadas por: elites (1-3), bosses (10-20), secretos (5), desafíos (variable)
- Gastadas en: El Santuario (pantalla entre runs)

**Desbloqueos Permanentes:**

| Categoría | Ejemplos | Coste en Almas |
|-----------|----------|---------------|
| **Armas** | Escopeta Ritual, Ametralladora de Guerra, Lanzallamas Sagrado | 20-50 |
| **Mejoras Pasivas** | +10% salud, +5% velocidad, +1 slot de arma inicial | 15-40 |
| **Habilidades Activas** | Dash, Doble Salto, Slow-Mo, Berserk | 30-60 |
| **Bendiciones** | Empezar con más munición, mejor drop rate | 25-50 |

### Progresión Dentro de Run

**Sistema de Niveles:**
- XP por kills, secretos, completar salas sin daño
- Al subir de nivel: elegir 1 de 3 power-ups temporales

**Power-ups Temporales (por run):**

| Rareza | Ejemplos |
|--------|----------|
| **Común** | +10% daño, +15% velocidad, +25% munición |
| **Raro** | Proyectiles que rebotan, +50% daño en espalda, vida por kill |
| **Épico** | Explosiones al impactar, inmunidad a fuego, doble salto |
| **Legendario** | Tiempo bala al esquivar, resurrección 1 vez, aura de daño |

---

## 4. ARMAS (8+ Tipos)

### Armas Base

| # | Nombre | Tipo | Daño | Cadencia | Munición | Especial |
|---|--------|------|------|----------|----------|----------|
| 1 | **Pistola del Culto** | Hitscan | 15 | 300ms | Infinita | Precisa, silenciosa |
| 2 | **Escopeta Ritual** | Hitscan | 60 | 800ms | Cartuchos | Spread alto, daño masivo cerca |
| 3 | **Ametralladora de Guerra** | Hitscan | 10 | 80ms | Balas | Cadencia alta, inestable |
| 4 | **Lanzallamas Sagrado** | Proyectil | 100 | 1200ms | Energía | Daño en área, quemadura |

### Armas Especiales (Desbloqueables)

| # | Nombre | Tipo | Daño | Especial |
|---|--------|------|------|----------|
| 5 | **Sierras del Tormento** | Proyectil | 40 | Rebotan 3 veces, sangrado |
| 6 | **Orbe del Vacío** | Proyectil | 75 | Agujero negro que atrae enemigos |
| 7 | **Cañón de Hueso** | Hitscan | 200 | Penetra enemigos, lento |
| 8 | **La Última Palabra** | Especial | ??? | 1 uso por run, mata todo en pantalla |

### Modificadores de Armas (Por Run)
- **+Daño**: +25% daño base
- **+Cadencia**: +30% velocidad de disparo
- **Rebote**: Proyectiles rebotan 1 vez más
- **Explosivo**: Impactos causan explosión menor
- **Vampírico**: 5% del daño se convierte en salud

---

## 5. ENEMIGOS (8+ Tipos)

### Zona 1: El Asilo (Cultistas)

| Enemigo | Comportamiento | Salud | Daño | Especial |
|---------|---------------|-------|------|----------|
| **Cultista Raso** | Dispara desde distancia media | 30 | 10 | Ninguno |
| **Flagelante** | Corre hacia el jugador, melee | 40 | 15 | Rápido |
| **Portador de la Vela** | Explota al morir | 25 | 30 (explosión) | Kamikaze |

### Zona 2: La Instalación (Híbridos)

| Enemigo | Comportamiento | Salud | Daño | Especial |
|---------|---------------|-------|------|----------|
| **Técnico Corrupto** | Dispara ráfagas, se teletransporta | 60 | 15 | Teletransporte |
| **Bestia de Carga** | Tanque, carga en línea recta | 150 | 30 | Resistente |
| **Enjambre Volador** | Vuela, dispara en abanico | 20 | 8 | Movimiento errático |

### Zona 3: El Umbral (Horrores)

| Enemigo | Comportamiento | Salud | Daño | Especial |
|---------|---------------|-------|------|----------|
| **Acechador** | Invisible hasta atacar | 80 | 25 | Sigilo |
| **Portavoz** | Invoca enemigos menores | 100 | 20 | Spawner |
| **Elite Corrupto** | Versión mejorada de cualquier tipo | x2 | x1.5 | Aura, modificadores |

### Bosses

| Boss | Zona | Mecánica |
|------|------|----------|
| **El Capellán Demente** | 1 | Invoca cultistas, cura a aliados |
| **Ingeniero Jefe Corrupto** | 2 | Torretas, escudos, áreas de daño |
| **Avatar del Vacío** | 3 | Teletransporte masivo, copias ilusorias |
| **El Que Susurra** | Final | Todas las mecánicas, fases múltiples |

---

## 6. NIVELES Y GENERACIÓN PROCEDURAL

### Estructura de Zonas

**Zona 1: El Asilo**
- Estética: Victorian-gótico, piedra gris, velas, símbolos arcanos
- Paleta: Grises, marrones, púrpura oscuro
- Enemigos: Cultistas humanos
- Música: Órgano, coros distantes, susurros

**Zona 2: La Instalación**
- Estética: Industrial, metal oxidado, tuberías, tecnología corrupta
- Paleta: Naranja óxido, verde espectral, negro
- Enemigos: Híbridos humano-máquina
- Música: Industrial, percusión metálica, drones

**Zona 3: El Umbral**
- Estética: Geometría imposible, carne y piedra fusionadas, vacío estrellado
- Paleta: Púrpura profundo, verde brillante, negro absoluto
- Enemigos: Horrores dimensionales
- Música: Disonante, reversa, sub-bass

### Tipos de Salas

| Tipo | Descripción | Recompensa |
|------|-------------|-----------|
| **Combate** | Horda de enemigos | XP, munición |
| **Élite** | Enemigo elite + minions | Almas, power-up |
| **Tesoro** | Sala sin enemigos, items | Salud, armadura, almas |
| **Tienda** | NPC comerciante | Comprar con moneda de run |
| **Altar** | Elegir 1 de 3 power-ups | Power-up temporal |
| **Secreto** | Oculta, requiere exploración | Lore, almas, arma única |
| **Boss** | Sala final de zona | Alma grande, desbloqueo |

---

## 7. INTERFAZ Y HUD

### HUD Durante Gameplay
```
┌─────────────────────────────────────────┐
│  [ARMA ACTUAL]        [NIVEL/ZONA]      │
│  [MUNICIÓN]           [ALMAS]           │
│                                         │
│           [CROSSHAIR]                   │
│                                         │
│  [POWER-UPS ACTIVOS]                    │
│                                         │
│  SALUD: ████████░░  ARMADURA: ██████░░  │
└─────────────────────────────────────────┘
```

### Pantallas Meta

**El Santuario (Entre Runs):**
- Árbol de desbloqueos visual
- Estadísticas de la run anterior
- Selección de loadout inicial
- Opciones de dificultad

---

## 8. AUDIO

### Música
- **Estilo**: Dark ambient, industrial, litúrgico corrupto
- **Referencias**: Doom (2016) pero más lento, Quake, Silent Hill
- **Implementación**: Capas que aumentan con la intensidad del combate

### Efectos de Sonido
- **Armas**: Pesadas, mecánicas, con rituales de recarga
- **Enemigos**: Voces distorsionadas, susurros, gritos no-humanos
- **Ambiente**: Viento, ecos, latidos, geometría que se mueve

---

## 9. MECÁNICA DE LOCURA (Opcional)

**Conocimiento Prohibido:**
- Recoger items de lore aumenta poder pero reduce "cordura"
- Baja cordura: visuales distorsionados, enemigos más agresivos, secretos visibles
- Cordura cero: ¿transformación? ¿game over especial?

---

## 10. ROADMAP DE DESARROLLO

### Fase 1: Prototipo (2 semanas)
- [ ] Raycasting básico
- [ ] Movimiento y disparo
- [ ] 1 nivel, 3 enemigos, 2 armas

### Fase 2: Vertical Slice (4 semanas)
- [ ] 1 zona completa
- [ ] Sistema roguelike básico
- [ ] 5 armas, 6 enemigos, 1 boss

### Fase 3: Contenido (6 semanas)
- [ ] 3 zonas completas
- [ ] 8 armas, 12 enemigos, 4 bosses
- [ ] Meta-progresión completa

### Fase 4: Polish (4 semanas)
- [ ] UI/UX completa
- [ ] Audio completo
- [ ] Balance y testing

---

*Documento creado por Iria Devon — 2026-10-08*
*Versión 1.0 — Inspiración: Lovecraft + Boltgun*
