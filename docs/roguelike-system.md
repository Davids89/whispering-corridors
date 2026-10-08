# SISTEMA ROGUELIKE — "WHISPERING CORRIDORS"

## 1. META-PROGRESIÓN (Persistente)

### Moneda Meta: ALMAS DEL VACÍO

**Cómo se ganan:**
| Fuente | Cantidad |
|--------|----------|
| Enemigo elite | 1-3 almas |
| Boss de zona | 10-20 almas |
| Secreto encontrado | 5 almas |
| Desafío completado | 5-15 almas |
| Run completada | 25 almas bonus |

**Dónde se gastan: EL SANTUARIO**

Pantalla entre runs con 4 categorías de desbloqueos:

```
EL SANTUARIO
├── ARMAS (6 slots iniciales)
│   ├── Escopeta Ritual — 20 almas
│   ├── Ametralladora de Guerra — 30 almas
│   ├── Lanzallamas Sagrado — 40 almas
│   ├── Sierras del Tormento — 50 almas
│   ├── Orbe del Vacío — 60 almas
│   └── Cañón de Hueso — 75 almas
│
├── MEJORAS PASIVAS (permanentes)
│   ├── Salud +10 (máx 5 niveles) — 15 almas/nivel
│   ├── Velocidad +5% (máx 5 niveles) — 20 almas/nivel
│   ├── Armadura inicial +25 — 25 almas
│   ├── Slot de arma inicial +1 — 40 almas
│   └── Suerte +10% (mejores drops) — 30 almas
│
├── HABILIDADES ACTIVAS (elegir 1 por run)
│   ├── Dash (impulso rápido) — 30 almas
│   ├── Doble Salto — 35 almas
│   ├── Slow-Mo (al esquivar) — 50 almas
│   └── Berserk (daño x2, defensa x0.5) — 60 almas
│
└── BENDICIONES (modificadores de run)
    ├── Munición inicial +50% — 20 almas
    ├── Enemigos elites +20% — 25 almas
    ├── Salas de tesoro +1 — 30 almas
    └── Precios de tienda -25% — 35 almas
```

---

## 2. PROGRESIÓN DENTRO DE RUN (Temporal)

### Sistema de Niveles

| Nivel | XP Requerido | Recompensa |
|-------|-------------|------------|
| 1 | 0 | - |
| 2 | 100 | Elegir 1 de 3 power-ups |
| 3 | 250 | Elegir 1 de 3 power-ups |
| 4 | 450 | Elegir 1 de 3 power-ups |
| 5 | 700 | Elegir 1 de 3 power-ups |
| ... | ... | ... |

**Fuentes de XP:**
- Kill de enemigo normal: 5 XP
- Kill de elite: 20 XP
- Sala completada sin daño: 15 XP
- Secreto encontrado: 10 XP
- Boss derrotado: 100 XP

### Power-ups Temporales (20+)

#### Comunes (50% drop rate)
| Nombre | Efecto |
|--------|--------|
| Ojo del Cazador | +15% daño |
| Pies Ligeros | +20% velocidad de movimiento |
| Bolsillos Profundos | +30% capacidad de munición |
| Piel de Hierro | +15% resistencia al daño |
| Reflejos Rápidos | +15% velocidad de recarga |

#### Raros (30% drop rate)
| Nombre | Efecto |
|--------|--------|
| Proyectiles Rebote | Balas rebotan 1 vez |
| Asesino Silencioso | +50% daño por la espalda |
| Vampirismo Menor | 3% del daño se convierte en salud |
| Explosión Controlada | Tus explosiones no te dañan |
| Manos Rápidas | Cambio de arma instantáneo |

#### Épicos (15% drop rate)
| Nombre | Efecto |
|--------|--------|
| Cadena de Explosiones | Kills causan explosión menor |
| Inmunidad Ígnea | Inmune a fuego y quemaduras |
| Salto Doble | Segundo salto en el aire |
| Aura de Debilidad | Enemigos cercanos reciben +20% daño |
| Segunda Oportunidad | Sobrevives con 1 HP una vez por run |

#### Legendarios (5% drop rate)
| Nombre | Efecto |
|--------|--------|
| Tiempo del Cazador | Slow-mo al esquivar por poco |
| Furia del Vacío | Daño x2 cuando salud < 30% |
| Resurrección | Revives con 50% salud al morir (1 vez) |
| Aura de Muerte | Enemigos que te tocan reciben daño |
| Ojo que Todo lo Ve | Mapa completo revelado, secretos marcados |

### Sistema de Elección

**Altares del Vacío:**
- Aparecen 1-2 por zona
- Al activar: 3 power-ups aleatorios para elegir 1
- Puedes pagar 5 almas para reroll (1 vez por altar)

**Tiendas:**
- Aparecen 1 por zona (a partir de Zona 2)
- Venden: power-ups, munición, salud, armadura
- Moneda: Cartuchos Rituales (moneda de run, no persistente)

---

## 3. ESTRUCTURA DE RUNS

### Configuración de Run

```
OPCIONES DE RUN
├── Dificultad
│   ├── Normal (estándar)
│   ├── Difícil (+25% enemigos, +50% almas)
│   ├── Pesadilla (+50% enemigos, +100% almas, elites más frecuentes)
│   └── Custom (modificadores individuales)
│
├── Loadout Inicial
│   ├── Arma 1: Pistola del Culto (siempre)
│   ├── Arma 2: [desbloqueable]
│   ├── Arma 3: [desbloqueable]
│   └── Habilidad: [si está desbloqueada]
│
└── Bendiciones (si están activas)
    └── [lista de bendiciones compradas]
```

### Flujo de una Run

```
INICIO
  │
  ▼
ZONA 1: El Asilo
  ├── Sala 1: Combate (tutorial suave)
  ├── Sala 2: Combate o Tesoro
  ├── Sala 3: Altar (elegir power-up)
  ├── Sala 4: Élite o Combate
  ├── Sala 5: Tienda (opcional)
  └── BOSS: El Capellán Demente
        │
        ▼ (victoria)
ZONA 2: La Instalación
  ├── 5-7 salas (más difíciles)
  └── BOSS: Ingeniero Jefe Corrupto
        │
        ▼ (victoria)
ZONA 3: El Umbral
  ├── 6-8 salas (máxima dificultad)
  └── BOSS: Avatar del Vacío
        │
        ▼ (victoria)
ZONA FINAL: El Trono
  └── BOSS FINAL: El Que Susurra
        │
        ▼ (victoria)
RUN COMPLETADA
  ├── Resumen de estadísticas
  ├── Almas ganadas
  └── Volver al Santuario
```

### Muerte

```
MUERTE
  │
  ▼
PANTALLA DE RESUMEN
├── Zona alcanzada
├── Enemigos eliminados
├── Tiempo de run
├── Almas ganadas (conservadas)
├── Power-ups perdidos
└── [Continuar al Santuario]
```

---

## 4. GENERACIÓN PROCEDURAL

### Algoritmo de Generación de Zonas

**Enfoque: Salas pre-diseñadas con conexiones procedurales**

1. **Pool de Salas**: 20-30 salas hand-crafted por zona
2. **Selección**: Elegir salas según reglas de distribución
3. **Conexión**: Grafos que garantizan camino válido
4. **Variación**: Rotaciones, espejos, variaciones de enemigos

### Distribución de Tipos de Sala por Zona

| Zona | Combate | Élite | Tesoro | Tienda | Altar | Secreto | Boss |
|------|---------|-------|--------|--------|-------|---------|------|
| 1 | 60% | 10% | 10% | 0% | 10% | 5% | 5% |
| 2 | 50% | 15% | 10% | 10% | 10% | 5% | 5% |
| 3 | 45% | 20% | 10% | 10% | 10% | 5% | 5% |

### Semillas

- Cada run tiene semilla única (visible para el jugador)
- Permite compartir runs específicas
- Semillas "diarias" para desafíos globales

---

## 5. BALANCE Y ESCALADO

### Escalado de Dificultad

| Factor | Zona 1 | Zona 2 | Zona 3 |
|--------|--------|--------|--------|
| Salud enemigos | x1.0 | x1.5 | x2.0 |
| Daño enemigos | x1.0 | x1.3 | x1.6 |
| Cantidad enemigos | x1.0 | x1.4 | x1.8 |
| Elites | 5% | 15% | 25% |

### Economía de Almas

**Objetivo**: Una run completa (30-45 min) = 50-80 almas
- Permite desbloquear 1-2 items por run
- Items caros requieren 3-5 runs

---

*Documento creado por Iria Devon — 2026-10-08*
