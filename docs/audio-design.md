# DISEÑO DE AUDIO — "WHISPERING CORRIDORS"
## Dirección Musical y Efectos de Sonido

---

## 1. VISIÓN GENERAL

**Estilo**: Dark ambient industrial con elementos litúrgicos corruptos
**Referencias**: 
- Doom (2016) — pero más lento y opresivo
- Quake — atmósfera industrial
- Silent Hill — disonancia y tensión
- Event Horizon — horror cósmico

**Filosofía**: El audio debe hacer sentir al jugador que está en un lugar **equivocado**, donde las leyes de la realidad se están deshaciendo.

---

## 2. MÚSICA POR ZONA

### Zona 1: El Asilo — "Requiem por los Cuerdos"

**Instrumentación**:
- Órgano de iglesia (distorsionado)
- Coro gregoriano (reversa, pitch down)
- Cuerdas disonantes (col legno, clusters)
- Percusión: latidos de corazón, cadenas

**Estructura**:
```
Intro (30s): Solo órgano, notas sostenidas, eco
Desarrollo: Añadir coro susurrante, cuerdas tensas
Clímax: Percusión ritual, órgano a todo volumen
Resolución: Silencio casi total, solo latido
```

**Implementación**:
- Capas que aumentan con enemigos en pantalla
- Stingers para eventos (puerta que se abre, secreto)
- Transición a combate: sub-bass entra

**Referencia de tempo**: 60-80 BPM (lento, pesado)

---

### Zona 2: La Instalación — "Máquinas de Tormento"

**Instrumentación**:
- Sintetizadores industriales (onda cuadrada, ruido)
- Percusión metálica (golpes en tuberías, metal)
- Drones de baja frecuencia
- Voces procesadas (radio distorsionada)

**Estructura**:
```
Intro (20s): Drones, estática
Desarrollo: Ritmo industrial, máquinas
Clímax: Percusión caótica, alarmas
Resolución: Zumbido eléctrico
```

**Implementación**:
- Más rítmica que Zona 1
- Sincronización con luces parpadeantes
- Sonidos de maquinaria como percusión

**Referencia de tempo**: 100-120 BPM (más rápido, mecánico)

---

### Zona 3: El Umbral — "Geometría del Vacío"

**Instrumentación**:
- Sintetizadores granulares (texturas imposibles)
- Cristales, cuencos tibetanos (reversa)
- Sub-bass extremo (sentir más que oír)
- Silencios abruptos

**Estructura**:
```
Intro (indefinido): Texturas ambientales
Desarrollo: Ritmos no-euclidianos (polirritmia)
Clímax: Todo se deshace en ruido blanco
Resolución: Silencio absoluto, luego susurro
```

**Implementación**:
- Menos "música", más "diseño de sonido"
- Efectos binaurales (auriculares)
- Música que reacciona a la locura del jugador

**Referencia de tempo**: Variable, libre

---

### Boss: El Capellán Demente — "Sermón Final"

**Tema**: Órgano + coro + percusión ritual
**Estructura**:
- Fase 1: Órgano majestuoso, coro latino
- Fase 2: Disonancia, coro distorsionado
- Fase 3: Caos total, todo superpuesto

---

## 3. EFECTOS DE SONIDO (SFX)

### Armas

| Arma | Disparo | Recarga | Especial |
|------|---------|---------|----------|
| **Pistola del Culto** | Pistoletazo seco, eco en pasillo | Cerrojo metálico, clic | Silenciador opcional |
| **Escopeta Ritual** | Explosión sorda, perdigones | Bombeo pesado, doble clic | Campana al matar |
| **Ametralladora de Guerra** | Ráfaga mecánica, casquillos | Cargador que cae, nuevo | Sobrecalentamiento |
| **Lanzallamas Sagrado** | Rugido de fuego, presión | Válvula de gas, chispa | Llama que se apaga |
| **Sierras del Tormento** | Zumbido de sierra, rebote | Engranes, hueso | Sangre al impactar |
| **Orbe del Vacío** | Susurro grave, succión | Energía que carga | Implosión |
| **Cañón de Hueso** | Trueno, crujido de hueso | Pesado, ritual | Eco en el vacío |
| **La Última Palabra** | Silencio absoluto, luego estallido | N/A | Silencio total 3s |

### Enemigos

| Enemigo | Alerta | Ataque | Muerte | Especial |
|---------|--------|--------|--------|----------|
| **Cultista** | Cántico latino | Disparo, grito | Grito ahogado | Rezando |
| **Flagelante** | Grito desgarrador | Cuchillos, pasos | Gorgoteo | Látigo |
| **Portador de Vela** | Siseo de vela | Pasos rápidos | Explosión, fuego | Mecha |
| **Técnico Corrupto** | Estática, radio | Descarga eléctrica | Apagado | Teletransporte |
| **Bestia de Carga** | Rugido metálico | Carga, golpe | Colapso | Pasos pesados |
| **Enjambre** | Zumbido de insectos | Escupitajo | Chapoteo | Alas |
| **Acechador** | Susurro cercano | Desgarramiento | Desvanecimiento | Invisibilidad |
| **Portavoz** | Canto ritual | Invocación | Silencio | Portal |

### Ambiente

| Ubicación | Sonidos |
|-----------|---------|
| **Pasillos** | Viento, crujidos, pasos lejanos, goteo |
| **Celdas** | Golpes en puertas, risas, llantos |
| **Capillas** | Cánticos, campanas, órgano distante |
| **Instalación** | Maquinaria, vapor, electricidad |
| **Umbral** | Susurros, geometría que se mueve, vacío |

### UI

| Acción | Sonido |
|--------|--------|
| Menú abrir | Página que se pasa |
| Seleccionar | Clic de pluma |
| Confirmar | Sello de cera |
| Cancelar | Papel que se rompe |
| Level up | Campana, coro |
| Power-up | Energía, brillo |
| Muerte | Latido que se detiene |
| Victoria | Silencio, luego coro |

---

## 4. IMPLEMENTACIÓN TÉCNICA

### Capas de Música

```javascript
class MusicManager {
    constructor() {
        this.layers = {
            ambient: null,    // Siempre activo
            tension: null,    // Enemigos cerca
            combat: null,     // En combate
            boss: null        // Boss fight
        };
        this.currentZone = 1;
        this.intensity = 0; // 0-1
    }
    
    update(enemiesNearby, inCombat, bossActive) {
        // Calcular intensidad
        this.intensity = enemiesNearby * 0.3 + (inCombat ? 0.5 : 0) + (bossActive ? 1 : 0);
        
        // Crossfade entre capas
        this.crossfadeLayers();
    }
    
    crossfadeLayers() {
        // Implementación de crossfade
    }
}
```

### Efectos 3D

- **Posicional**: Sonidos de enemigos según posición
- **Oclusión**: Paredes bloquean sonido
- **Reverberación**: Diferente según tamaño de sala
- **Doppler**: Para enemigos que se mueven rápido

---

## 5. RECURSOS NECESARIOS

### Samples a Crear/Conseguir

**Prioridad Alta (P0)**:
- [ ] Disparo de pistola (3 variantes)
- [ ] Disparo de escopeta (2 variantes)
- [ ] Explosión pequeña
- [ ] Pasos en piedra (4 variantes)
- [ ] Puerta que se abre (2 variantes)
- [ ] Grito de cultista (3 variantes)

**Prioridad Media (P1)**:
- [ ] Música de Zona 1 (loop 2 min)
- [ ] Música de combate (loop 1 min)
- [ ] Efectos de ambiente de asilo
- [ ] Sonidos de UI básicos

**Prioridad Baja (P2)**:
- [ ] Música de Zona 2 y 3
- [ ] Efectos de armas especiales
- [ ] Voces de enemigos completas

### Fuentes CC0 Sugeridas

| Recurso | Fuente | Uso |
|---------|--------|-----|
| Freesound.org | Varios | SFX base |
| OpenGameArt | Varios | Música placeholder |
| Sonniss GDC | Pack gratis | SFX profesionales |
| BBC Sound Effects | BBC | Ambientes |

---

## 6. MEZCLA Y MASTERIZACIÓN

### Niveles de Referencia

| Elemento | Nivel (dB) |
|----------|-----------|
| Música | -18 dB |
| SFX armas | -12 dB |
| SFX enemigos | -14 dB |
| Ambiente | -22 dB |
| UI | -16 dB |
| Voz | -10 dB |

### Efectos de Master

- **Compresión**: Suave, para mantener dinámica
- **Reverb**: Sala grande, mezcla 20%
- **EQ**: Boost en 100Hz (peso), cut en 5kHz (no fatiga)
- **Limitador**: -3dB ceiling

---

*Documento creado por Iria Devon — 2026-10-08*
