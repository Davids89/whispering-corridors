// ============================================
// SISTEMA DE ENEMIGOS — "WHISPERING CORRIDORS"
// Estilo: Lovecraft + Boltgun
// ============================================

/**
 * Estados de la máquina de estados
 */
const EnemyState = {
    IDLE: 'idle',
    PATROL: 'patrol',
    CHASE: 'chase',
    ATTACK: 'attack',
    FLEE: 'flee',
    DIE: 'die',
    STUNNED: 'stunned',
    SPAWN: 'spawn'
};

/**
 * Tipos de comportamiento
 */
const BehaviorType = {
    RUSHER: 'rusher',      // Corre hacia el jugador
    SHOOTER: 'shooter',    // Mantiene distancia, dispara
    TANK: 'tank',          // Lento, mucha salud
    EXPLODER: 'exploder',  // Explota cerca del jugador
    FLYER: 'flyer',        // Vuela, movimiento errático
    TELEPORTER: 'teleporter', // Se teletransporta
    SPAWNER: 'spawner',    // Genera enemigos
    SNIPER: 'sniper'       // Dispara desde lejos con precisión
};

/**
 * Clase base de Enemigo
 */
class Enemy {
    constructor(config) {
        this.id = config.id;
        this.name = config.name;
        this.description = config.description;
        
        // Stats base
        this.maxHealth = config.health;
        this.health = config.health;
        this.damage = config.damage;
        this.speed = config.speed;
        this.attackRange = config.attackRange || 1.5;
        this.attackRate = config.attackRate || 1000; // ms
        this.sightRange = config.sightRange || 10;
        this.hearingRange = config.hearingRange || 8;
        
        // Comportamiento
        this.behavior = config.behavior;
        this.state = EnemyState.IDLE;
        this.stateTimer = 0;
        
        // Posición y movimiento
        this.x = config.x || 0;
        this.y = config.y || 0;
        this.targetX = this.x;
        this.targetY = this.y;
        this.velocityX = 0;
        this.velocityY = 0;
        
        // Pathfinding
        this.path = [];
        this.pathIndex = 0;
        this.repathTimer = 0;
        
        // Combate
        this.lastAttackTime = 0;
        this.target = null; // Referencia al jugador
        
        // Elite
        this.isElite = config.isElite || false;
        this.eliteModifiers = config.eliteModifiers || [];
        
        // Drops
        this.soulDrop = config.soulDrop || 0;
        this.itemDrops = config.itemDrops || [];
        
        // Visual
        this.sprite = config.sprite;
        this.scale = config.scale || 1;
        this.auraColor = config.auraColor || null;
        
        // Audio
        this.sounds = config.sounds || {};
        
        // Estado especial
        this.isFlying = config.isFlying || false;
        this.canTeleport = config.canTeleport || false;
        this.explodesOnDeath = config.explodesOnDeath || false;
        this.explosionDamage = config.explosionDamage || 0;
        this.explosionRadius = config.explosionRadius || 0;
    }
    
    /**
     * Actualización por frame
     */
    update(deltaTime, player, level) {
        if (this.state === EnemyState.DIE) return;
        
        this.stateTimer += deltaTime;
        this.repathTimer += deltaTime;
        
        // Actualizar máquina de estados
        this.updateState(player, level);
        
        // Ejecutar comportamiento actual
        switch (this.state) {
            case EnemyState.IDLE:
                this.updateIdle(deltaTime, player, level);
                break;
            case EnemyState.PATROL:
                this.updatePatrol(deltaTime, player, level);
                break;
            case EnemyState.CHASE:
                this.updateChase(deltaTime, player, level);
                break;
            case EnemyState.ATTACK:
                this.updateAttack(deltaTime, player, level);
                break;
            case EnemyState.FLEE:
                this.updateFlee(deltaTime, player, level);
                break;
            case EnemyState.STUNNED:
                // No hacer nada
                break;
        }
        
        // Aplicar movimiento
        this.x += this.velocityX * deltaTime;
        this.y += this.velocityY * deltaTime;
        
        // Verificar colisiones con nivel
        this.resolveCollisions(level);
    }
    
    /**
     * Actualiza la máquina de estados
     */
    updateState(player, level) {
        const distToPlayer = this.distanceTo(player);
        const canSeePlayer = this.canSee(player, level);
        const canHearPlayer = distToPlayer < this.hearingRange;
        
        switch (this.state) {
            case EnemyState.IDLE:
                if (canSeePlayer || canHearPlayer) {
                    this.setState(EnemyState.CHASE);
                    this.target = player;
                } else if (this.stateTimer > 3000) {
                    this.setState(EnemyState.PATROL);
                }
                break;
                
            case EnemyState.PATROL:
                if (canSeePlayer || canHearPlayer) {
                    this.setState(EnemyState.CHASE);
                    this.target = player;
                } else if (this.stateTimer > 5000) {
                    this.setState(EnemyState.IDLE);
                }
                break;
                
            case EnemyState.CHASE:
                if (!canSeePlayer && !canHearPlayer) {
                    this.setState(EnemyState.IDLE);
                    this.target = null;
                } else if (distToPlayer < this.attackRange) {
                    this.setState(EnemyState.ATTACK);
                }
                break;
                
            case EnemyState.ATTACK:
                if (distToPlayer > this.attackRange * 1.5) {
                    this.setState(EnemyState.CHASE);
                }
                break;
                
            case EnemyState.FLEE:
                if (this.stateTimer > 2000) {
                    this.setState(EnemyState.IDLE);
                }
                break;
        }
    }
    
    /**
     * Comportamiento IDLE
     */
    updateIdle(deltaTime, player, level) {
        this.velocityX = 0;
        this.velocityY = 0;
    }
    
    /**
     * Comportamiento PATROL
     */
    updatePatrol(deltaTime, player, level) {
        // Movimiento aleatorio simple
        if (this.stateTimer % 2000 < 50) {
            const angle = Math.random() * Math.PI * 2;
            this.velocityX = Math.cos(angle) * this.speed * 0.3;
            this.velocityY = Math.sin(angle) * this.speed * 0.3;
        }
    }
    
    /**
     * Comportamiento CHASE
     */
    updateChase(deltaTime, player, level) {
        if (!this.target) return;
        
        // Pathfinding simple: moverse directamente hacia el objetivo
        const dx = this.target.x - this.x;
        const dy = this.target.y - this.y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        
        if (dist > 0) {
            this.velocityX = (dx / dist) * this.speed;
            this.velocityY = (dy / dist) * this.speed;
        }
        
        // Comportamientos especiales
        if (this.behavior === BehaviorType.TELEPORTER && this.canTeleport) {
            if (this.stateTimer > 3000 && Math.random() < 0.01) {
                this.teleportNearPlayer(player, level);
            }
        }
        
        if (this.behavior === BehaviorType.FLYER) {
            // Movimiento errático
            this.velocityX += (Math.random() - 0.5) * this.speed * 0.5;
            this.velocityY += (Math.random() - 0.5) * this.speed * 0.5;
        }
    }
    
    /**
     * Comportamiento ATTACK
     */
    updateAttack(deltaTime, player, level) {
        if (!this.target) return;
        
        const currentTime = Date.now();
        if (currentTime - this.lastAttackTime < this.attackRate) return;
        
        this.lastAttackTime = currentTime;
        
        // Ejecutar ataque según tipo
        switch (this.behavior) {
            case BehaviorType.RUSHER:
                this.meleeAttack(player);
                break;
            case BehaviorType.SHOOTER:
                this.rangedAttack(player);
                break;
            case BehaviorType.EXPLODER:
                this.explode(player);
                break;
            case BehaviorType.SPAWNER:
                this.spawnMinions(level);
                break;
            case BehaviorType.SNIPER:
                this.snipeAttack(player);
                break;
            default:
                this.meleeAttack(player);
        }
    }
    
    /**
     * Comportamiento FLEE
     */
    updateFlee(deltaTime, player, level) {
        if (!this.target) return;
        
        // Huir en dirección opuesta
        const dx = this.x - this.target.x;
        const dy = this.y - this.target.y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        
        if (dist > 0) {
            this.velocityX = (dx / dist) * this.speed * 1.5;
            this.velocityY = (dy / dist) * this.speed * 1.5;
        }
    }
    
    /**
     * Ataque melee
     */
    meleeAttack(player) {
        // Verificar si está en rango
        if (this.distanceTo(player) <= this.attackRange) {
            player.takeDamage(this.damage, this);
        }
    }
    
    /**
     * Ataque a distancia
     */
    rangedAttack(player) {
        // Crear proyectil
        const dx = player.x - this.x;
        const dy = player.y - this.y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        
        if (dist > 0) {
            const projectile = {
                x: this.x,
                y: this.y,
                velocityX: (dx / dist) * 10,
                velocityY: (dy / dist) * 10,
                damage: this.damage,
                owner: this
            };
            
            // Añadir al mundo (el engine lo gestionará)
            if (this.onShoot) {
                this.onShoot(projectile);
            }
        }
    }
    
    /**
     * Ataque de francotirador
     */
    snipeAttack(player) {
        // Rayo preciso, daño alto
        if (this.distanceTo(player) <= this.sightRange) {
            player.takeDamage(this.damage * 1.5, this);
        }
    }
    
    /**
     * Explosión
     */
    explode(player) {
        if (this.distanceTo(player) <= this.explosionRadius) {
            player.takeDamage(this.explosionDamage, this);
        }
        this.die();
    }
    
    /**
     * Genera minions
     */
    spawnMinions(level) {
        // Implementado por el gestor de enemigos
        if (this.onSpawn) {
            this.onSpawn(this);
        }
    }
    
    /**
     * Teletransporte cerca del jugador
     */
    teleportNearPlayer(player, level) {
        const angle = Math.random() * Math.PI * 2;
        const dist = 3 + Math.random() * 3;
        
        const newX = player.x + Math.cos(angle) * dist;
        const newY = player.y + Math.sin(angle) * dist;
        
        // Verificar que la posición es válida
        if (level.isWalkable(newX, newY)) {
            this.x = newX;
            this.y = newY;
        }
    }
    
    /**
     * Recibe daño
     */
    takeDamage(amount, source) {
        // Reducción de daño por armadura/elite
        let finalDamage = amount;
        
        if (this.isElite) {
            finalDamage *= 0.8; // 20% reducción
        }
        
        this.health -= finalDamage;
        
        // Efecto de hit
        this.onHit(finalDamage, source);
        
        if (this.health <= 0) {
            this.die();
        } else if (this.health < this.maxHealth * 0.3 && this.behavior !== BehaviorType.EXPLODER) {
            // Posibilidad de huir con poca salud
            if (Math.random() < 0.3) {
                this.setState(EnemyState.FLEE);
            }
        }
    }
    
    /**
     * Muerte del enemigo
     */
    die() {
        this.setState(EnemyState.DIE);
        
        // Drops
        if (this.onDeath) {
            this.onDeath(this);
        }
        
        // Explosión post-mortem
        if (this.explodesOnDeath) {
            // Daño en área
        }
    }
    
    /**
     * Cambia de estado
     */
    setState(newState) {
        this.state = newState;
        this.stateTimer = 0;
    }
    
    /**
     * Distancia al objetivo
     */
    distanceTo(target) {
        const dx = target.x - this.x;
        const dy = target.y - this.y;
        return Math.sqrt(dx * dx + dy * dy);
    }
    
    /**
     * Verifica línea de visión
     */
    canSee(target, level) {
        // Raycast simple
        const steps = 10;
        const dx = (target.x - this.x) / steps;
        const dy = (target.y - this.y) / steps;
        
        for (let i = 1; i < steps; i++) {
            const x = this.x + dx * i;
            const y = this.y + dy * i;
            if (!level.isWalkable(x, y)) {
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * Resuelve colisiones con el nivel
     */
    resolveCollisions(level) {
        // Implementación simple: no atravesar paredes
        if (!level.isWalkable(this.x, this.y)) {
            // Retroceder
            this.x -= this.velocityX * 0.016;
            this.y -= this.velocityY * 0.016;
            this.velocityX = 0;
            this.velocityY = 0;
        }
    }
    
    /**
     * Callback cuando es golpeado
     */
    onHit(damage, source) {
        // Override en subclases o asignar función
    }
    
    /**
     * Callback cuando muere
     */
    onDeath(enemy) {
        // Override en subclases o asignar función
    }
    
    /**
     * Callback cuando dispara
     */
    onShoot(projectile) {
        // Override en subclases o asignar función
    }
    
    /**
     * Callback cuando spawnea minions
     */
    onSpawn(spawner) {
        // Override en subclases o asignar función
    }
}

// ============================================
// DEFINICIÓN DE ENEMIGOS
// ============================================

const ENEMIES = {
    // ============ ZONA 1: EL ASILO ============
    
    CULTIST: {
        id: 'cultist',
        name: 'Cultista Raso',
        description: 'Devoto del Vacío. Dispara desde distancia media.',
        health: 30,
        damage: 10,
        speed: 2,
        attackRange: 8,
        attackRate: 1500,
        sightRange: 12,
        behavior: BehaviorType.SHOOTER,
        soulDrop: 1,
        sprite: 'cultist_sprite',
        sounds: {
            alert: 'cultist_chant',
            attack: 'cultist_shot',
            death: 'cultist_scream'
        }
    },
    
    FLAGELLANT: {
        id: 'flagellant',
        name: 'Flagelante',
        description: 'Penitente enloquecido. Corre hacia el jugador con cuchillas.',
        health: 40,
        damage: 15,
        speed: 4,
        attackRange: 1.5,
        attackRate: 800,
        sightRange: 10,
        behavior: BehaviorType.RUSHER,
        soulDrop: 1,
        sprite: 'flagellant_sprite',
        sounds: {
            alert: 'flagellant_scream',
            attack: 'flagellant_slash',
            death: 'flagellant_gurgle'
        }
    },
    
    CANDLE_BEARER: {
        id: 'candle_bearer',
        name: 'Portador de la Vela',
        description: 'Cultista suicida. Explota al acercarse al jugador.',
        health: 25,
        damage: 5,
        speed: 3,
        attackRange: 2,
        attackRate: 500,
        sightRange: 15,
        behavior: BehaviorType.EXPLODER,
        explodesOnDeath: true,
        explosionDamage: 30,
        explosionRadius: 3,
        soulDrop: 2,
        sprite: 'candle_bearer_sprite',
        sounds: {
            alert: 'candle_hiss',
            death: 'explosion_small'
        }
    },
    
    // ============ ZONA 2: LA INSTALACIÓN ============
    
    CORRUPT_TECHNICIAN: {
        id: 'corrupt_technician',
        name: 'Técnico Corrupto',
        description: 'Ingeniero fusionado con maquinaria. Se teletransporta y dispara ráfagas.',
        health: 60,
        damage: 15,
        speed: 2.5,
        attackRange: 10,
        attackRate: 2000,
        sightRange: 14,
        behavior: BehaviorType.TELEPORTER,
        canTeleport: true,
        soulDrop: 2,
        sprite: 'technician_sprite',
        sounds: {
            alert: 'technician_static',
            attack: 'technician_zap',
            teleport: 'teleport_warp',
            death: 'technician_shutdown'
        }
    },
    
    CARGO_BEAST: {
        id: 'cargo_beast',
        name: 'Bestia de Carga',
        description: 'Monstruosidad de carne y metal. Carga en línea recta.',
        health: 150,
        damage: 30,
        speed: 1.5,
        attackRange: 2,
        attackRate: 1500,
        sightRange: 8,
        behavior: BehaviorType.TANK,
        soulDrop: 3,
        sprite: 'cargo_beast_sprite',
        sounds: {
            alert: 'beast_roar',
            attack: 'beast_charge',
            death: 'beast_collapse'
        }
    },
    
    FLYING_SWARM: {
        id: 'flying_swarm',
        name: 'Enjambre Volador',
        description: 'Criaturas aladas que disparan en abanico.',
        health: 20,
        damage: 8,
        speed: 3.5,
        attackRange: 6,
        attackRate: 1200,
        sightRange: 12,
        behavior: BehaviorType.FLYER,
        isFlying: true,
        soulDrop: 1,
        sprite: 'swarm_sprite',
        sounds: {
            alert: 'swarm_buzz',
            attack: 'swarm_spit',
            death: 'swarm_splat'
        }
    },
    
    // ============ ZONA 3: EL UMBRAL ============
    
    STALKER: {
        id: 'stalker',
        name: 'Acechador',
        description: 'Horror invisible que solo se revela al atacar.',
        health: 80,
        damage: 25,
        speed: 3,
        attackRange: 2,
        attackRate: 1000,
        sightRange: 20,
        behavior: BehaviorType.RUSHER,
        soulDrop: 3,
        sprite: 'stalker_sprite',
        sounds: {
            alert: 'stalker_whisper',
            attack: 'stalker_shriek',
            death: 'stalker_fade'
        }
    },
    
    VOID_SPEAKER: {
        id: 'void_speaker',
        name: 'Portavoz del Vacío',
        description: 'Entidad que invoca horrores menores.',
        health: 100,
        damage: 20,
        speed: 1,
        attackRange: 12,
        attackRate: 3000,
        sightRange: 15,
        behavior: BehaviorType.SPAWNER,
        soulDrop: 5,
        sprite: 'speaker_sprite',
        sounds: {
            alert: 'speaker_chant',
            spawn: 'spawn_ritual',
            death: 'speaker_silence'
        }
    },
    
    // ============ ELITES ============
    
    ELITE_CULTIST: {
        id: 'elite_cultist',
        name: 'Cultista Élite',
        description: 'Líder de culto con poderes oscuros.',
        health: 80,
        damage: 20,
        speed: 2.5,
        attackRange: 10,
        attackRate: 1200,
        sightRange: 15,
        behavior: BehaviorType.SHOOTER,
        isElite: true,
        eliteModifiers: ['double_shot', 'health_regen'],
        soulDrop: 5,
        auraColor: '#8b00ff',
        sprite: 'elite_cultist_sprite'
    },
    
    ELITE_BEAST: {
        id: 'elite_beast',
        name: 'Bestia Alfa',
        description: 'Versión mejorada de la Bestia de Carga.',
        health: 300,
        damage: 45,
        speed: 2,
        attackRange: 2.5,
        attackRate: 1200,
        sightRange: 10,
        behavior: BehaviorType.TANK,
        isElite: true,
        eliteModifiers: ['charge_attack', 'damage_aura'],
        soulDrop: 8,
        auraColor: '#ff4400',
        sprite: 'elite_beast_sprite'
    }
};

// ============================================
// GESTOR DE ENEMIGOS
// ============================================

class EnemyManager {
    constructor() {
        this.enemies = [];
        this.spawnQueue = [];
        this.maxEnemies = 50; // Límite para performance
    }
    
    /**
     * Genera enemigos para una sala
     */
    spawnRoomEnemies(room, difficulty, playerLevel) {
        const enemyCount = this.calculateEnemyCount(room, difficulty);
        const enemies = [];
        
        for (let i = 0; i < enemyCount; i++) {
            const enemyType = this.selectEnemyType(room.zone, difficulty);
            const position = this.getSpawnPosition(room);
            
            const enemy = this.createEnemy(enemyType, position.x, position.y, difficulty);
            enemies.push(enemy);
        }
        
        // Posibilidad de elite
        if (Math.random() < this.getEliteChance(difficulty)) {
            const eliteType = this.selectEliteType(room.zone);
            const position = this.getSpawnPosition(room);
            const elite = this.createEnemy(eliteType, position.x, position.y, difficulty);
            enemies.push(elite);
        }
        
        return enemies;
    }
    
    /**
     * Crea una instancia de enemigo
     */
    createEnemy(typeId, x, y, difficulty) {
        const template = ENEMIES[typeId.toUpperCase()];
        if (!template) return null;
        
        // Escalar stats por dificultad
        const scale = 1 + (difficulty - 1) * 0.3;
        
        const enemy = new Enemy({
            ...template,
            x,
            y,
            health: Math.floor(template.health * scale),
            damage: Math.floor(template.damage * scale)
        });
        
        return enemy;
    }
    
    /**
     * Calcula cantidad de enemigos para una sala
     */
    calculateEnemyCount(room, difficulty) {
        const baseCount = 3 + Math.floor(difficulty * 2);
        const variance = Math.floor(Math.random() * 3);
        return Math.min(baseCount + variance, this.maxEnemies - this.enemies.length);
    }
    
    /**
     * Selecciona tipo de enemigo según zona y dificultad
     */
    selectEnemyType(zone, difficulty) {
        const zoneEnemies = {
            1: ['cultist', 'flagellant', 'candle_bearer'],
            2: ['cultist', 'corrupt_technician', 'cargo_beast', 'flying_swarm'],
            3: ['corrupt_technician', 'stalker', 'void_speaker', 'flying_swarm']
        };
        
        const available = zoneEnemies[zone] || zoneEnemies[1];
        return available[Math.floor(Math.random() * available.length)];
    }
    
    /**
     * Selecciona tipo de elite
     */
    selectEliteType(zone) {
        const elites = {
            1: ['elite_cultist'],
            2: ['elite_cultist', 'elite_beast'],
            3: ['elite_beast', 'elite_cultist']
        };
        
        const available = elites[zone] || elites[1];
        return available[Math.floor(Math.random() * available.length)];
    }
    
    /**
     * Probabilidad de elite según dificultad
     */
    getEliteChance(difficulty) {
        return Math.min(0.05 + difficulty * 0.05, 0.25);
    }
    
    /**
     * Obtiene posición de spawn válida
     */
    getSpawnPosition(room) {
        // Posición aleatoria dentro de la sala
        const margin = 1;
        const x = room.x + margin + Math.random() * (room.width - margin * 2);
        const y = room.y + margin + Math.random() * (room.height - margin * 2);
        return { x, y };
    }
    
    /**
     * Actualiza todos los enemigos
     */
    update(deltaTime, player, level) {
        for (let i = this.enemies.length - 1; i >= 0; i--) {
            const enemy = this.enemies[i];
            enemy.update(deltaTime, player, level);
            
            // Eliminar muertos
            if (enemy.state === EnemyState.DIE && enemy.stateTimer > 1000) {
                this.enemies.splice(i, 1);
            }
        }
        
        // Procesar cola de spawn
        while (this.spawnQueue.length > 0 && this.enemies.length < this.maxEnemies) {
            const spawn = this.spawnQueue.shift();
            this.enemies.push(spawn);
        }
    }
    
    /**
     * Añade enemigos al mundo
     */
    addEnemies(enemies) {
        this.spawnQueue.push(...enemies);
    }
    
    /**
     * Limpia enemigos muertos
     */
    clearDead() {
        this.enemies = this.enemies.filter(e => e.state !== EnemyState.DIE);
    }
}

// Exportar
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        Enemy,
        ENEMIES,
        EnemyManager,
        EnemyState,
        BehaviorType
    };
}
