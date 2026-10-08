# DISEÑO DE UI/HUD — "WHISPERING CORRIDORS"
## Interfaz de Usuario y Experiencia

---

## 1. FILOSOFÍA DE DISEÑO

**Principios**:
- **Legibilidad**: Información clara en el caos del combate
- **Inmersión**: UI que se siente parte del mundo (diegetic cuando sea posible)
- **Estilo**: Pixel art coherente, paleta lovecraftiana
- **Minimalismo**: Solo lo esencial en pantalla durante gameplay

**Inspiración**:
- Doom (2016): HUD limpio, información contextual
- Boltgun: Números grandes, estilo retro
- Bloodborne: Elegancia gótica, tipografía

---

## 2. HUD DURANTE GAMEPLAY

### Layout Principal

```
┌─────────────────────────────────────────────────────────┐
│  [ZONA] ▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│                                                         │
│  [ARMA ACTUAL]                    [POWER-UPS ACTIVOS]   │
│  ┌─────────────┐                  ┌─────┐ ┌─────┐      │
│  │             │                  │  +  │ │  🔥 │      │
│  │   SPRITE    │                  │ DMG │ │ FIRE│      │
│  │    ARMA     │                  └─────┘ └─────┘      │
│  │             │                                       │
│  └─────────────┘                                       │
│  Munición: 12/∞                                        │
│                                                         │
│                                                         │
│                    [CROSSHAIR]                          │
│                                                         │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │ SALUD    ████████████████░░░░░░░░  75/100       │   │
│  │ ARMADURA ██████████░░░░░░░░░░░░░░  40/100       │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  [ALMAS: 15]                              [NIVEL: 3]   │
└─────────────────────────────────────────────────────────┘
```

### Elementos del HUD

#### Barra de Zona (Superior)
- **Propósito**: Progreso en la zona actual
- **Visual**: Barra horizontal con segmentos por sala
- **Colores**: 
  - Completado: Verde espectral (#3a8b5a)
  - Actual: Púrpura brillante (#8b00ff)
  - Pendiente: Gris oscuro (#3a3a42)

#### Indicador de Arma (Izquierda)
- **Sprite**: Vista en primera persona del arma
- **Animación**: Idle sway, recoil al disparar, reload
- **Munición**: Número grande, color según tipo:
  - Infinita: Blanco hueso (#e8e0d0)
  - Normal: Amarillo (#c9a227)
  - Baja: Naranja (#ff6600)
  - Vacía: Rojo parpadeante (#ff0000)

#### Power-ups Activos (Derecha)
- **Iconos**: 32x32 pixels, borde según rareza
- **Tooltip**: Nombre al pasar mouse (o mantener botón)
- **Duración**: Barra de progreso circular

#### Barras de Estado (Inferior)
- **Salud**: Rojo sangre (#8b0000), números grandes
- **Armadura**: Azul acero (#4a6a8a), absorbe daño primero
- **Efectos**: 
  - Daño: Flash rojo en pantalla
  - Curación: Partículas verdes
  - Armadura rota: Sonido de cristal, icono roto

#### Información Meta (Esquinas)
- **Almas**: Icono de alma + número, brillo al ganar
- **Nivel**: Número romano, XP bar circular alrededor

---

## 3. PANTALLAS META

### El Santuario (Entre Runs)

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│              ╔═══════════════════════╗                  │
│              ║   EL SANTUARIO        ║                  │
│              ╚═══════════════════════╝                  │
│                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │    ARMAS    │  │   MEJORAS   │  │ HABILIDADES │     │
│  │             │  │             │  │             │     │
│  │  [Iconos]   │  │  [Iconos]   │  │  [Iconos]   │     │
│  │             │  │             │  │             │     │
│  │  6 slots    │  │  5 niveles  │  │  4 slots    │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │              BENDICIONES ACTIVAS                 │   │
│  │  [✓] Munición +50%  [✓] Elites +20%  [ ] ...    │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  ALMAS DISPONIBLES: 45                           │   │
│  │                                                 │   │
│  │  [COMPRAR SELECCIONADO]  [VENDER]  [CANCELAR]   │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│              [INICIAR RUN]  [OPCIONES]  [SALIR]         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Pantalla de Resumen de Run

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│              ╔═══════════════════════╗                  │
│              ║   RUN COMPLETADA      ║                  │
│              ╚═══════════════════════╝                  │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  ESTADÍSTICAS                                    │   │
│  │  ─────────────────────────────────────────────  │   │
│  │  Tiempo total:        34:27                      │   │
│  │  Zona alcanzada:      3 - El Umbral              │   │
│  │  Enemigos eliminados: 247                        │   │
│  │  Elites eliminados:   12                         │   │
│  │  Bosses derrotados:   2                          │   │
│  │  Secretos encontrados: 4/6                       │   │
│  │  Precisión:           68%                        │   │
│  │  Daño recibido:       1,247                      │   │
│  │  Daño infligido:      45,890                     │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  RECOMPENSAS                                     │   │
│  │  ─────────────────────────────────────────────  │   │
│  │  Almas ganadas:       +67                        │   │
│  │  Power-ups usados:    8                          │   │
│  │  Armas encontradas:   3                          │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  DESBLOQUEOS DISPONIBLES                         │   │
│  │  ─────────────────────────────────────────────  │   │
│  │  [NUEVO] Escopeta Ritual        - 20 almas      │   │
│  │  [NUEVO] Mejora: Salud +10      - 15 almas      │   │
│  │  [NUEVO] Habilidad: Dash        - 30 almas      │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│         [IR AL SANTUARIO]  [NUEVA RUN]  [MENÚ]          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Pantalla de Selección de Dificultad

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│              ╔═══════════════════════╗                  │
│              ║   NUEVA RUN           ║                  │
│              ╚═══════════════════════╝                  │
│                                                         │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │
│  │   NORMAL    │ │   DIFÍCIL   │ │  PESADILLA  │       │
│  │             │ │             │ │             │       │
│  │  Estándar   │ │  +25% enem. │ │  +50% enem. │       │
│  │  Para todos │ │  +50% almas │ │  +100% almas│       │
│  │             │ │             │ │  Elites +   │       │
│  │  [SELECC.]  │ │  [SELECC.]  │ │  [SELECC.]  │       │
│  └─────────────┘ └─────────────┘ └─────────────┘       │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  MODIFICADORES PERSONALIZADOS                    │   │
│  │  ─────────────────────────────────────────────  │   │
│  │  [ ] Solo pistola          [ ] Sin power-ups    │   │
│  │  [ ] Enemigos rápidos      [ ] Daño x2          │   │
│  │  [ ] Sin checkpoints       [ ] Permadeath real  │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  LOADOUT INICIAL                                 │   │
│  │  ─────────────────────────────────────────────  │   │
│  │  Arma 1: [Pistola del Culto ▼]                  │   │
│  │  Arma 2: [Vacío ▼]                              │   │
│  │  Arma 3: [Vacío ▼]                              │   │
│  │  Habilidad: [Ninguna ▼]                         │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│              [COMENZAR]  [VOLVER]                       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 4. MENÚS

### Menú Principal

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│                                                         │
│              ╔═══════════════════════╗                  │
│              ║                       ║                  │
│              ║   WHISPERING          ║                  │
│              ║   CORRIDORS           ║                  │
│              ║                       ║                  │
│              ╚═══════════════════════╝                  │
│                                                         │
│                                                         │
│                   [CONTINUAR]                           │
│                                                         │
│                   [NUEVA RUN]                           │
│                                                         │
│                   [EL SANTUARIO]                        │
│                                                         │
│                   [OPCIONES]                            │
│                                                         │
│                   [CRÉDITOS]                            │
│                                                         │
│                   [SALIR]                               │
│                                                         │
│                                                         │
│         v0.1.0-alpha                    [ALMAS: 45]     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Menú de Pausa

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│              ╔═══════════════════════╗                  │
│              ║      PAUSA            ║                  │
│              ╚═���═════════════════════╝                  │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  ESTADO ACTUAL                                   │   │
│  │  Zona: 1 - El Asilo    Sala: 4/6    Nivel: 2    │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│                   [REANUDAR]                            │
│                                                         │
│                   [OPCIONES]                            │
│                                                         │
│                   [REINICIAR SALA]                      │
│                                                         │
│                   [ABANDONAR RUN]                       │
│                                                         │
│                   [MENÚ PRINCIPAL]                      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Opciones

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│              ╔═══════════════════════╗                  │
│              ║     OPCIONES          ║                  │
│              ╚═══════════════════════╝                  │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  VÍDEO                                           │   │
│  │  Resolución:     [1920x1080 ▼]                  │   │
│  │  Escala:         [4x ▼]                         │   │
│  │  Filtro:         [Ninguno ▼]                    │   │
│  │  Brillo:         [████████░░] 80%               │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  AUDIO                                           │   │
│  │  Maestro:        [████████░░] 80%               │   │
│  │  Música:         [██████░░░░] 60%               │   │
│  │  SFX:            [████████░░] 80%               │   │
│  │  Voz:            [███████░░░] 70%               │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  CONTROLES                                       │   │
│  │  Sensibilidad:   [██████░░░░] 60%               │   │
│  │  Invertir Y:     [ ]                            │   │
│  │  [CONFIGURAR TECLAS]                            │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│              [APLICAR]  [CANCELAR]  [POR DEFECTO]       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 5. ELEMENTOS VISUALES

### Tipografía

| Uso | Fuente | Tamaño | Color |
|-----|--------|--------|-------|
| Títulos | Pixel Gothic | 32px | #c9a227 |
| Subtítulos | Pixel Gothic | 24px | #a9871a |
| Cuerpo | Pixel Sans | 16px | #e8e0d0 |
| Números grandes | Pixel Numbers | 48px | #ffffff |
| HUD | Pixel Sans Bold | 20px | Variable |

### Colores de UI

| Elemento | Normal | Hover | Activo | Deshabilitado |
|----------|--------|-------|--------|---------------|
| Botón | #3a3a42 | #4a4a52 | #5a5a62 | #2a2a32 |
| Texto botón | #e8e0d0 | #ffffff | #c9a227 | #5a5a62 |
| Borde | #5a5a62 | #c9a227 | #8b00ff | #3a3a42 |
| Fondo panel | #1a1a22cc | - | - | - |
| Barra progreso | #3a3a42 | - | #c9a227 | - |

### Iconos

| Icono | Tamaño | Descripción |
|-------|--------|-------------|
| Salud | 16x16 | Cruz roja |
| Armadura | 16x16 | Escudo azul |
| Almas | 16x16 | Llama púrpura |
| Munición | 16x16 | Balas |
| Power-up | 32x32 | Variable según tipo |
| Arma | 64x64 | Sprite del arma |

---

## 6. ANIMACIONES Y TRANSICIONES

### Transiciones de Pantalla

| De | A | Efecto | Duración |
|----|---|--------|----------|
| Menú | Juego | Fade to black + partículas | 1s |
| Juego | Pausa | Desenfoque + oscurecer | 0.3s |
| Muerte | Resumen | Rojo a negro, latido | 2s |
| Victoria | Santuario | Blanco a dorado | 1.5s |

### Animaciones de UI

| Elemento | Animación | Trigger |
|----------|-----------|---------|
| Botón | Escala 1.1x, brillo | Hover |
| Barra salud | Pulso rojo | Daño recibido |
| Almas | Partículas subiendo | Al ganar |
| Power-up | Rotación, brillo | Al activar |
| Level up | Explosión de luz | Al subir nivel |

---

## 7. ACCESIBILIDAD

### Opciones de Accesibilidad

- **Subtítulos**: Para todos los diálogos y sonidos importantes
- **Alto contraste**: Modo para daltonismo
- **Tamaño de texto**: 3 tamaños seleccionables
- **Reducción de movimiento**: Desactivar screen shake, flashes
- **Ayuda de aim**: Opción de asistencia de puntería

---

*Documento creado por Iria Devon — 2026-10-08*
