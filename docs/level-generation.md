# SISTEMA DE GENERACIÓN PROCEDURAL DE NIVELES
## "WHISPERING CORRIDORS"

---

## 1. ENFOQUE GENERAL

**Método: Salas Pre-diseñadas + Conexiones Procedurales**

Inspirado en Hades, Dead Cells y Enter the Gungeon:
- Calidad de diseño hand-crafted
- Variabilidad y replayability procedural
- Control de dificultad y pacing

---

## 2. ESTRUCTURA DE DATOS

### Representación de Sala

```javascript
class Room {
    id: string;              // "combat_01", "elite_02", etc.
    type: RoomType;          // COMBAT, ELITE, TREASURE, SHOP, ALTAR, SECRET, BOSS
    zone: number;            // 1, 2, 3 (dificultad)
    width: number;           // En tiles (16x16 típico)
    height: number;
    layout: number[][];      // Grid de tiles
    doors: Door[];           // Puertas de conexión
    enemies: EnemySpawn[];   // Enemigos pre-colocados
    items: ItemSpawn[];      // Items pre-colocados
    tags: string[];          // "vertical", "horizontal", "hub", "corridor"
}

class Door {
    x: number;
    y: number;
    direction: Direction;    // NORTH, SOUTH, EAST, WEST
    width: number;           // 1-3 tiles
    locked: boolean;         // Requiere llave/evento
}
```

### Representación de Zona

```javascript
class Zone {
    id: number;              // 1, 2, 3
    name: string;            // "El Asilo", "La Instalación", "El Umbral"
    roomCount: [min, max];   // [4,6], [5,7], [6,8]
    rooms: Room[];           // Pool de salas disponibles
    connections: Connection[]; // Grafo de conexiones
    bossRoom: Room;          // Sala de boss (siempre al final)
}
```

---

## 3. ALGORITMO DE GENERACIÓN

### Paso 1: Selección de Salas

```javascript
function generateZone(zoneId, seed) {
    const zone = ZONES[zoneId];
    const rng = new SeededRandom(seed);
    const roomCount = rng.range(zone.roomCount[0], zone.roomCount[1]);
    
    // Distribución de tipos
    const distribution = getRoomDistribution(zoneId, roomCount);
    
    // Seleccionar salas del pool
    const selectedRooms = [];
    for (const [type, count] of Object.entries(distribution)) {
        const available = zone.rooms.filter(r => r.type === type);
        for (let i = 0; i < count; i++) {
            const room = available[rng.range(0, available.length)];
            selectedRooms.push(room.clone());
        }
    }
    
    return selectedRooms;
}
```

### Paso 2: Construcción del Grafo

```javascript
function buildRoomGraph(rooms, rng) {
    // Crear grafo conexo
    const graph = new Graph();
    
    // Añadir nodos
    for (const room of rooms) {
        graph.addNode(room);
    }
    
    // Conectar con árbol de expansión mínima + conexiones extra
    const mst = minimumSpanningTree(rooms, rng);
    for (const edge of mst) {
        graph.addEdge(edge.from, edge.to);
    }
    
    // Añadir 1-2 conexiones extra para loops
    const extraConnections = rng.range(1, 3);
    for (let i = 0; i < extraConnections; i++) {
        const a = rooms[rng.range(0, rooms.length)];
        const b = rooms[rng.range(0, rooms.length)];
        if (a !== b && !graph.hasEdge(a, b)) {
            graph.addEdge(a, b);
        }
    }
    
    return graph;
}
```

### Paso 3: Asignación de Posiciones

```javascript
function assignPositions(graph, rng) {
    const positions = new Map();
    const startRoom = graph.nodes.find(r => r.type === RoomType.START);
    
    // BFS para asignar posiciones
    const queue = [{ room: startRoom, x: 0, y: 0 }];
    positions.set(startRoom, { x: 0, y: 0 });
    
    while (queue.length > 0) {
        const { room, x, y } = queue.shift();
        
        for (const neighbor of graph.getNeighbors(room)) {
            if (!positions.has(neighbor)) {
                // Calcular posición basada en puertas disponibles
                const pos = calculateNeighborPosition(room, neighbor, x, y, rng);
                positions.set(neighbor, pos);
                queue.push({ room: neighbor, ...pos });
            }
        }
    }
    
    return positions;
}
```

### Paso 4: Generación del Tilemap

```javascript
function generateTilemap(rooms, positions, connections) {
    // Calcular bounds totales
    const bounds = calculateBounds(rooms, positions);
    const width = bounds.maxX - bounds.minX + 20; // Margen
    const height = bounds.maxY - bounds.minY + 20;
    
    // Inicializar grid vacío
    const tilemap = Array(height).fill().map(() => Array(width).fill(TileType.VOID));
    
    // Colocar salas
    for (const [room, pos] of positions) {
        placeRoom(tilemap, room, pos.x - bounds.minX + 10, pos.y - bounds.minY + 10);
    }
    
    // Conectar con pasillos
    for (const conn of connections) {
        const roomA = conn.from;
        const roomB = conn.to;
        const posA = positions.get(roomA);
        const posB = positions.get(roomB);
        
        generateCorridor(tilemap, roomA, posA, roomB, posB);
    }
    
    return tilemap;
}
```

---

## 4. TIPOS DE SALAS POR ZONA

### Zona 1: El Asilo

| Tipo | Cantidad | Descripción |
|------|----------|-------------|
| **Combate** | 3-4 | Celdas, salas de estar, capillas pequeñas |
| **Élite** | 0-1 | Sala de tortura, biblioteca prohibida |
| **Tesoro** | 1 | Celda del tesoro, escondite secreto |
| **Altar** | 1 | Capilla corrupta |
| **Secreto** | 0-1 | Pasaje oculto, habitación sellada |
| **Boss** | 1 | Capilla mayor |

**Características:**
- Corredores estrechos (1-2 tiles)
- Muchas puertas, algunas cerradas
- Iluminación tenue (velas, lámparas)
- Texturas: piedra gris, madera podrida, símbolos arcanos

### Zona 2: La Instalación

| Tipo | Cantidad | Descripción |
|------|----------|-------------|
| **Combate** | 3-4 | Salas de máquinas, laboratorios, pasillos industriales |
| **Élite** | 1-2 | Reactor principal, sala de control |
| **Tesoro** | 1 | Almacén, caja fuerte |
| **Tienda** | 1 | Taller del comerciante |
| **Altar** | 1 | Núcleo de energía corrupto |
| **Secreto** | 0-1 | Conducto de ventilación, sala de servidores |
| **Boss** | 1 | Sala de máquinas principal |

**Características:**
- Espacios más abiertos
- Elementos industriales (tuberías, máquinas)
- Iluminación artificial (luces parpadeantes)
- Texturas: metal oxidado, paneles de control, energía verde

### Zona 3: El Umbral

| Tipo | Cantidad | Descripción |
|------|----------|-------------|
| **Combate** | 4-5 | Plataformas flotantes, templos imposibles |
| **Élite** | 2 | Nexos de energía, altares mayores |
| **Tesoro** | 1 | Cámara del vacío |
| **Tienda** | 1 | Mercader dimensional |
| **Altar** | 1-2 | Fisuras entre mundos |
| **Secreto** | 1 | Geometría imposible, habitación espejo |
| **Boss** | 1 | Trono del Avatar |

**Características:**
- Geometría no euclidiana (visualmente)
- Plataformas flotantes, gravedad variable
- Iluminación espectral (verde, púrpura)
- Texturas: carne, piedra viva, vacío estrellado

---

## 5. REGLAS DE GENERACIÓN

### Reglas de Conexión

1. **Conectividad**: Todas las salas deben ser alcanzables
2. **Progresión**: El camino al boss debe pasar por al menos 1 sala de combate
3. **Secretos**: Las salas secretas no están en el camino principal
4. **Tiendas**: Siempre accesibles, nunca bloquean progresión
5. **Altares**: Máximo 1 por zona, nunca en la primera sala

### Reglas de Dificultad

```javascript
function calculateDifficulty(room, zone, roomIndex, totalRooms) {
    let difficulty = zone; // Base: 1, 2, 3
    
    // Escalado por posición en la zona
    difficulty += (roomIndex / totalRooms) * 0.5;
    
    // Bonus por tipo de sala
    if (room.type === RoomType.ELITE) difficulty += 0.5;
    if (room.type === RoomType.BOSS) difficulty += 1.0;
    
    return difficulty;
}
```

### Escalado de Enemigos

| Dificultad | Salud | Daño | Cantidad | Elites |
|------------|-------|------|----------|--------|
| 1.0 | x1.0 | x1.0 | x1.0 | 5% |
| 1.5 | x1.3 | x1.2 | x1.2 | 10% |
| 2.0 | x1.6 | x1.4 | x1.4 | 15% |
| 2.5 | x2.0 | x1.6 | x1.6 | 20% |
| 3.0 | x2.5 | x1.8 | x1.8 | 25% |

---

## 6. SEMILLAS Y REPRODUCIBILIDAD

### Formato de Semilla

```
WHISPER-XXXX-XXXX-XXXX
│       │    │    └── Variación de contenido
│       │    └──────── Configuración de zona
│       └───────────── Tipo de run
└───────────────────── Prefijo del juego
```

### Uso de Semillas

```javascript
class SeededRandom {
    constructor(seed) {
        this.seed = hashString(seed);
    }
    
    next() {
        // LCG (Linear Congruential Generator)
        this.seed = (this.seed * 1664525 + 1013904223) % 4294967296;
        return this.seed / 4294967296;
    }
    
    range(min, max) {
        return Math.floor(this.next() * (max - min)) + min;
    }
    
    choice(array) {
        return array[this.range(0, array.length)];
    }
}
```

### Semillas Especiales

| Tipo | Formato | Descripción |
|------|---------|-------------|
| **Diaria** | DAILY-YYYYMMDD | Misma para todos, leaderboard global |
| **Semanal** | WEEKLY-YYYYWW | Más difícil, mejores recompensas |
| **Custom** | WHISPER-XXXX-XXXX | Compartible entre jugadores |

---

## 7. IMPLEMENTACIÓN TÉCNICA

### Flujo de Generación

```
1. INICIO DE RUN
   └── Generar semilla (o usar proporcionada)
   
2. POR CADA ZONA
   ├── Seleccionar salas del pool
   ├── Construir grafo de conexiones
   ├── Asignar posiciones
   ├── Generar tilemap
   ├── Colocar enemigos y items
   └── Verificar completitud
   
3. VALIDACIÓN
   ├── ¿Es completable?
   ├── ¿Hay camino al boss?
   ├── ¿Los secretos son accesibles?
   └── ¿La dificultad es apropiada?
   
4. CARGA
   └── Instanciar nivel en el engine
```

### Optimizaciones

- **Pre-generación**: Generar todas las zonas al inicio de la run
- **Carga asíncrona**: Cargar zonas en background mientras se juega
- **Pooling**: Reutilizar objetos de enemigos/items entre salas

---

*Documento creado por Iria Devon — 2026-10-08*
