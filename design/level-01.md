# DISEÑO DE NIVEL 01 — "EL ASILO"
## Whispering Corridors

---

## 1. VISIÓN GENERAL

**Tema**: Asilo victoriano corrupto, convertido en centro de culto
**Paleta**: Grises piedra, marrones madera podrida, púrpura oscuro, verde espectral (acentos)
**Música**: Órgano distante, coros susurrantes, latidos de corazón
**Enemigos**: Cultistas, Flagelantes, Portadores de Vela
**Boss**: El Capellán Demente

---

## 2. LAYOUT DEL NIVEL

```
                    [N]
                     │
    [S3]═══[C2]═══[C3]═══[S4]
     ║      ║      ║      ║
    [C1]   [A1]   [C4]   [T1]
     ║      ║      ║      ║
    [S2]═══[C5]═══[C6]═══[S5]
                     │
                    [B1]

Leyenda:
- S#: Salas de Secretos
- C#: Salas de Combate
- A#: Altar
- T#: Tesoro
- B#: Boss
- ═/║: Conexiones
```

---

## 3. DESCRIPCIÓN DE SALAS

### ENTRADA: Vestíbulo del Asilo (C1)

**Tamaño**: 8x8 tiles
**Descripción**: Recepción abandonada. Mostrador de madera podrida, sillas volcadas, papeles por el suelo.
**Enemigos**: 2 Cultistas (tutorial suave)
**Items**: 
- Botiquín pequeño (esquina NE)
- Munición de pistola (detrás del mostrador)
**Secreto**: Puerta falsa en pared norte → S1

**Iluminación**: Tenue, lámpara parpadeante
**Audio**: Viento, crujidos de madera

---

### SALA DE ESTAR (C2)

**Tamaño**: 12x10 tiles
**Descripción**: Sala común con sofás rotos, chimenea apagada, cuadros retorcidos.
**Enemigos**: 3 Cultistas, 1 Flagelante
**Items**:
- Botiquín mediano (chimenea)
- Armadura ligera (armario)
**Setpiece**: Cuadro que "sigue" al jugador (efecto visual)

**Iluminación**: Chimenea con brasas, velas
**Audio**: Susurros, pasos distantes

---

### CAPILLA PEQUEÑA (C3)

**Tamaño**: 10x12 tiles
**Descripción**: Capilla privada del asilo. Bancos destrozados, altar profanado, símbolos arcanos en las paredes.
**Enemigos**: 4 Cultistas, 2 Flagelantes
**Items**:
- Munición de escopeta (altar)
- Botiquín grande (confesionario)
**Setpiece**: Estatua que llora sangre

**Iluminación**: Velas rojas, luz púrpura del altar
**Audio**: Cánticos distorsionados, campanas

---

### CELDAS DE AISLAMIENTO (C4)

**Tamaño**: 14x8 tiles
**Descripción**: Pasillo con celdas a ambos lados. Algunas puertas abiertas, otras cerradas con barrotes.
**Enemigos**: 3 Flagelantes (salen de celdas), 2 Cultistas
**Items**:
- Granada de fuego (celda 3)
- Llave del ala este (celda 5, requiere buscar)
**Mecánica**: Puertas que se abren al acercarse (jump scare)

**Iluminación**: Luz verde de emergencia, oscuridad total en celdas
**Audio**: Golpes en puertas, risas distantes

---

### SALA DE TERROR (C5)

**Tamaño**: 10x10 tiles
**Descripción**: Habitación circular con símbolo arcano en el suelo. Pilares retorcidos.
**Enemigos**: 2 Portadores de Vela (primera aparición), 3 Cultistas
**Items**:
- Almas x3 (centro del símbolo)
- Power-up aleatorio (altar pequeño)
**Setpiece**: El símbolo brilla cuando entras

**Iluminación**: Luz púrpura del símbolo, oscuridad total en bordes
**Audio**: Latido de corazón, susurros intensificados

---

### BIBLIOTECA PROHIBIDA (C6)

**Tamaño**: 12x12 tiles
**Descripción**: Estanterías altas, libros prohibidos, escaleras de caracol.
**Enemigos**: 4 Cultistas, 2 Flagelantes, 1 Portador de Vela
**Items**:
- Tomo de lore (historia del asilo)
- Munición variada
- Botiquín grande
**Mecánica**: Libros que vuelan (obstáculos móviles)

**Iluminación**: Lámparas de lectura verdes
**Audio**: Páginas que se pasan solas, susurros de libros

---

### ALTAR DEL VACÍO (A1)

**Tamaño**: 6x6 tiles
**Descripción**: Pequeña capilla lateral con altar de piedra negra.
**Mecánica**: Elegir 1 de 3 power-ups temporales
**Coste**: Ninguno (primer altar gratis)

**Iluminación**: Luz verde espectral
**Audio**: Eco, voces superpuestas

---

### TESORO DEL DIRECTOR (T1)

**Tamaño**: 8x8 tiles
**Descripción**: Oficina del director del asilo. Escritorio, caja fuerte, retratos.
**Items**:
- Almas x5 (caja fuerte)
- Arma: Escopeta Ritual (si no está desbloqueada, aparece como pickup temporal)
- Botiquín completo
- Armadura completa
**Mecánica**: Caja fuerte requiere encontrar combinación (pista en nota)

**Iluminación**: Lámpara de escritorio
**Audio**: Tictac de reloj, viento en chimenea

---

### SECRETO 1: CELDA OCULTA (S1)

**Tamaño**: 4x4 tiles
**Acceso**: Puerta falsa en C1
**Contenido**:
- Almas x3
- Nota de lore (paciente 742)
- Power-up: +10% daño

---

### SECRETO 2: PASAJE SUBTERRÁNEO (S2)

**Tamaño**: 6x4 tiles
**Acceso**: Trampilla bajo alfombra en C2
**Contenido**:
- Almas x2
- Munición especial
- Visión breve del "otro lado" (efecto visual)

---

### SECRETO 3: HABITACIÓN DEL ESPEJO (S3)

**Tamaño**: 5x5 tiles
**Acceso**: Espejo roto en C3
**Contenido**:
- Almas x4
- Skin cosmético para arma
- Enemigo: Reflejo corrupto (mini-boss opcional)

---

### SECRETO 4: ARCHIVO SECRETO (S4)

**Tamaño**: 6x6 tiles
**Acceso**: Estantería móvil en C6
**Contenido**:
- Almas x3
- Documentos del culto
- Mapa parcial de la zona 2

---

### SECRETO 5: CÁMARA DE CONTENCIÓN (S5)

**Tamaño**: 8x6 tiles
**Acceso**: Puerta sellada en C5 (requiere llave de C4)
**Contenido**:
- Almas x5
- Arma especial: Sierras del Tormento (pickup temporal)
- Boss opcional: El Prisionero

---

### BOSS: CAPILLA MAYOR (B1)

**Tamaño**: 16x16 tiles
**Descripción**: Capilla principal del asilo. Bancos destrozados, altar mayor profanado, vidrieras rotas.

**Boss: El Capellán Demente**
- **Fase 1**: Invoca cultistas menores (3-5), ataca con báculo (proyectiles)
- **Fase 2** (50% salud): Se cura, invoca más enemigos, áreas de daño en el suelo
- **Fase 3** (25% salud): Velocidad aumentada, ataques más frecuentes, invocación continua

**Mecánicas**:
- Destruir focos de invocación para parar adds
- Esquivar áreas de daño (círculos púrpura)
- Atacar cuando se cura (ventana de vulnerabilidad)

**Recompensas**:
- Almas x15
- Desbloqueo: Zona 2
- Power-up legendario garantizado
- Logro: "Purificador del Asilo"

**Iluminación**: Vidrieras rotas proyectan luz púrpura y verde
**Audio**: Órgano distorsionado, coro demoníaco, campanas rotas

---

## 4. FLUJO DE PROGRESIÓN

```
INICIO
  │
  ▼
[C1] Vestíbulo ─────────────────┐
  │                             │
  ▼                             │
[C2] Sala de Estar              │
  │                             │
  ├──→ [S2] Secreto (opcional)  │
  │                             │
  ▼                             │
[C3] Capilla Pequeña            │
  │                             │
  ├──→ [S3] Secreto (opcional)  │
  │                             │
  ▼                             │
[A1] Altar (power-up)           │
  │                             │
  ▼                             │
[C4] Celdas ──→ Llave           │
  │                             │
  ├──→ [S4] Secreto (opcional)  │
  │                             │
  ▼                             │
[C5] Sala de Terror             │
  │                             │
  ├──→ [S5] Secreto (con llave) │
  │                             │
  ▼                             │
[C6] Biblioteca                 │
  │                             │
  ├──→ [S1] Secreto (vuelta)    │
  │                             │
  ▼                             │
[T1] Tesoro                     │
  │                             │
  ▼                             │
[B1] BOSS: Capellán Demente ←───┘
  │
  ▼
ZONA 2 DESBLOQUEADA
```

---

## 5. TABLA DE ENEMIGOS Y RECOMPENSAS

| Sala | Enemigos | Cantidad | XP | Almas | Items |
|------|----------|----------|-----|-------|-------|
| C1 | Cultista | 2 | 10 | 0 | Botiquín, munición |
| C2 | Cultista, Flagelante | 4 | 25 | 0 | Botiquín, armadura |
| C3 | Cultista, Flagelante | 6 | 40 | 0 | Munición escopeta |
| C4 | Flagelante, Cultista | 5 | 35 | 0 | Granada, llave |
| C5 | Portador, Cultista | 5 | 45 | 3 | Power-up |
| C6 | Cultista, Flagelante, Portador | 7 | 60 | 0 | Lore, munición |
| A1 | - | 0 | 0 | 0 | Power-up |
| T1 | - | 0 | 0 | 5 | Arma, botiquín, armadura |
| S1 | - | 0 | 10 | 3 | Power-up |
| S2 | - | 0 | 10 | 2 | Munición |
| S3 | Reflejo | 1 | 30 | 4 | Skin |
| S4 | - | 0 | 10 | 3 | Documentos |
| S5 | Prisionero | 1 | 50 | 5 | Arma especial |
| B1 | Capellán + adds | 1+ | 200 | 15 | Desbloqueo |

**Totales**: ~515 XP, ~35 almas (sin contar drops aleatorios)

---

## 6. PALETA DE COLORES

| Elemento | Color Principal | Color Secundario | Acento |
|----------|----------------|------------------|--------|
| Paredes | #4a4a52 | #3a3a42 | #2a2a32 |
| Suelo | #5a4a3a | #4a3a2a | #3a2a1a |
| Techos | #2a2a32 | #1a1a22 | #0a0a12 |
| Madera | #6a5a4a | #5a4a3a | #4a3a2a |
| Piedra | #5a5a62 | #4a4a52 | #3a3a42 |
| Velas | #c9a227 | #a9871a | #8b6d0d |
| Corrupción | #4a1a5a | #3a0a4a | #2a053a |
| Energía | #3a8b5a | #2a7b4a | #1a6b3a |

---

## 7. NOTAS DE IMPLEMENTACIÓN

### Texturas Necesarias
- [ ] Piedra del asilo (3 variantes)
- [ ] Madera podrida (2 variantes)
- [ ] Símbolos arcanos (4 variantes)
- [ ] Puertas de celda (2 variantes)
- [ ] Estanterías de libros
- [ ] Altar de piedra negra
- [ ] Vidrieras rotas

### Sprites Necesarios
- [ ] Cultista (idle, caminar, disparar, morir)
- [ ] Flagelante (idle, correr, atacar, morir)
- [ ] Portador de Vela (idle, correr, explotar)
- [ ] El Capellán Demente (idle, atacar, curar, invocar, morir)
- [ ] Reflejo corrupto (idle, atacar)
- [ ] El Prisionero (idle, atacar)

### Efectos Especiales
- [ ] Partículas de polvo en luz
- [ ] Velas parpadeantes
- [ ] Símbolo que brilla
- [ ] Libros que vuelan
- [ ] Sangre en paredes
- [ ] Ectoplasma verde

---

*Documento creado por Iria Devon — 2026-10-08*
