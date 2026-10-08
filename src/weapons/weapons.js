// ============================================
// SISTEMA DE ARMAS — "WHISPERING CORRIDORS"
// Estilo: Lovecraft + Boltgun
// ============================================

/**
 * Tipos de munición
 */
const AmmoType = {
    BULLETS: 'bullets',      // Balas estándar
    SHELLS: 'shells',        // Cartuchos de escopeta
    ROCKETS: 'rockets',      // Cohetes/explosivos
    ENERGY: 'energy',        // Energía warp
    INFINITE: 'infinite'     // Munición infinita (pistola)
};

/**
 * Tipos de daño
 */
const DamageType = {
    PHYSICAL: 'physical',    // Daño físico estándar
    FIRE: 'fire',            // Daño por fuego/quemadura
    EXPLOSIVE: 'explosive',  // Daño en área
    VOID: 'void',            // Daño dimensional (ignora armadura)
    BLEED: 'bleed'           // Daño por sangrado (DoT)
};

/**
 * Clase base de Arma
 */
class Weapon {
    constructor(config) {
        this.id = config.id;
        this.name = config.name;
        this.description = config.description;
        
        // Stats base
        this.damage = config.damage;
        this.fireRate = config.fireRate;        // ms entre disparos
        this.reloadTime = config.reloadTime || 1000; // ms
        this.magazineSize = config.magazineSize || 1;
        this.ammoType = config.ammoType;
        this.damageType = config.damageType || DamageType.PHYSICAL;
        
        // Comportamiento
        this.spread = config.spread || 0;       // Dispersión en radianes
        this.recoil = config.recoil || 0;       // Retroceso visual
        this.pellets = config.pellets || 1;     // Proyectiles por disparo (escopeta)
        this.projectileSpeed = config.projectileSpeed || 0; // 0 = hitscan
        this.explosionRadius = config.explosionRadius || 0;
        
        // Estado
        this.currentAmmo = this.magazineSize;
        this.reserveAmmo = config.reserveAmmo || Infinity;
        this.isReloading = false;
        this.lastShotTime = 0;
        
        // Modificadores (por run)
        this.modifiers = [];
        
        // Visual
        this.sprite = config.sprite;
        this.muzzleFlash = config.muzzleFlash;
        this.sound = config.sound;
        
        // Desbloqueo
        this.unlocked = config.unlocked || false;
        this.unlockCost = config.unlockCost || 0;
    }
    
    /**
     * Intenta disparar el arma
     */
    canShoot(currentTime) {
        if (this.isReloading) return false;
        if (this.currentAmmo <= 0) return false;
        if (currentTime - this.lastShotTime < this.fireRate) return false;
        return true;
    }
    
    /**
     * Dispara el arma
     */
    shoot(currentTime, position, direction) {
        if (!this.canShoot(currentTime)) return null;
        
        this.lastShotTime = currentTime;
        this.currentAmmo--;
        
        // Aplicar modificadores
        const modifiedDamage = this.getModifiedDamage();
        const modifiedSpread = this.getModifiedSpread();
        
        // Crear proyectiles
        const projectiles = [];
        for (let i = 0; i < this.pellets; i++) {
            const spreadAngle = (Math.random() - 0.5) * modifiedSpread * 2;
            const finalDirection = this.rotateVector(direction, spreadAngle);
            
            projectiles.push({
                position: { ...position },
                direction: finalDirection,
                speed: this.projectileSpeed,
                damage: modifiedDamage,
                damageType: this.damageType,
                explosionRadius: this.explosionRadius,
                weapon: this
            });
        }
        
        // Auto-recargar si está vacío
        if (this.currentAmmo <= 0 && this.reserveAmmo > 0) {
            this.reload();
        }
        
        return {
            projectiles,
            muzzleFlash: this.muzzleFlash,
            sound: this.sound,
            recoil: this.recoil
        };
    }
    
    /**
     * Recarga el arma
     */
    reload() {
        if (this.isReloading) return false;
        if (this.currentAmmo >= this.magazineSize) return false;
        if (this.reserveAmmo <= 0) return false;
        
        this.isReloading = true;
        
        setTimeout(() => {
            const ammoNeeded = this.magazineSize - this.currentAmmo;
            const ammoToLoad = Math.min(ammoNeeded, this.reserveAmmo);
            
            this.currentAmmo += ammoToLoad;
            if (this.reserveAmmo !== Infinity) {
                this.reserveAmmo -= ammoToLoad;
            }
            
            this.isReloading = false;
        }, this.reloadTime);
        
        return true;
    }
    
    /**
     * Añade un modificador temporal (por run)
     */
    addModifier(modifier) {
        this.modifiers.push(modifier);
    }
    
    /**
     * Calcula el daño modificado
     */
    getModifiedDamage() {
        let damage = this.damage;
        for (const mod of this.modifiers) {
            if (mod.type === 'damage') {
                damage *= (1 + mod.value);
            }
        }
        return damage;
    }
    
    /**
     * Calcula la dispersión modificada
     */
    getModifiedSpread() {
        let spread = this.spread;
        for (const mod of this.modifiers) {
            if (mod.type === 'spread') {
                spread *= (1 + mod.value);
            }
        }
        return spread;
    }
    
    /**
     * Rota un vector 2D
     */
    rotateVector(vec, angle) {
        const cos = Math.cos(angle);
        const sin = Math.sin(angle);
        return {
            x: vec.x * cos - vec.y * sin,
            y: vec.x * sin + vec.y * cos
        };
    }
    
    /**
     * Serialización para guardado
     */
    serialize() {
        return {
            id: this.id,
            currentAmmo: this.currentAmmo,
            reserveAmmo: this.reserveAmmo,
            modifiers: this.modifiers
        };
    }
}

// ============================================
// DEFINICIÓN DE ARMAS
// ============================================

const WEAPONS = {
    // ============ ARMAS INICIALES ============
    
    PISTOL: new Weapon({
        id: 'pistol',
        name: 'Pistola del Culto',
        description: 'Arma estándar de los cultistas. Fiiable, silenciosa, siempre contigo.',
        damage: 15,
        fireRate: 300,
        reloadTime: 800,
        magazineSize: 12,
        ammoType: AmmoType.INFINITE,
        spread: 0.02,
        recoil: 0.1,
        unlocked: true, // Siempre desbloqueada
        sprite: 'pistol_sprite',
        muzzleFlash: 'flash_small',
        sound: 'pistol_shot'
    }),
    
    // ============ ARMAS DESBLOQUEABLES ============
    
    SHOTGUN: new Weapon({
        id: 'shotgun',
        name: 'Escopeta Ritual',
        description: 'Cañones bendecidos con sangre de mártir. Devastadora a corta distancia.',
        damage: 12, // Por perdigón
        fireRate: 800,
        reloadTime: 1500,
        magazineSize: 6,
        ammoType: AmmoType.SHELLS,
        spread: 0.15,
        recoil: 0.4,
        pellets: 8,
        unlocked: false,
        unlockCost: 20,
        sprite: 'shotgun_sprite',
        muzzleFlash: 'flash_large',
        sound: 'shotgun_blast'
    }),
    
    MACHINEGUN: new Weapon({
        id: 'machinegun',
        name: 'Ametralladora de Guerra',
        description: 'Reliquia de la Gran Guerra. Escupe plomo a ritmo infernal.',
        damage: 10,
        fireRate: 80,
        reloadTime: 2000,
        magazineSize: 50,
        ammoType: AmmoType.BULLETS,
        spread: 0.08,
        recoil: 0.15,
        unlocked: false,
        unlockCost: 30,
        sprite: 'machinegun_sprite',
        muzzleFlash: 'flash_rapid',
        sound: 'machinegun_burst'
    }),
    
    FLAMETHROWER: new Weapon({
        id: 'flamethrower',
        name: 'Lanzallamas Sagrado',
        description: 'Fuego purificador alimentado por aceite consagrado.',
        damage: 25,
        fireRate: 100,
        reloadTime: 2500,
        magazineSize: 100,
        ammoType: AmmoType.ENERGY,
        damageType: DamageType.FIRE,
        spread: 0.05,
        projectileSpeed: 15,
        unlocked: false,
        unlockCost: 40,
        sprite: 'flamethrower_sprite',
        muzzleFlash: 'flash_fire',
        sound: 'flamethrower_roar'
    }),
    
    // ============ ARMAS ESPECIALES ============
    
    SAWBLADE: new Weapon({
        id: 'sawblade',
        name: 'Sierras del Tormento',
        description: 'Discos de hueso afilado que buscan carne. Rebotan entre enemigos.',
        damage: 40,
        fireRate: 600,
        reloadTime: 1200,
        magazineSize: 8,
        ammoType: AmmoType.ENERGY,
        damageType: DamageType.BLEED,
        spread: 0.03,
        projectileSpeed: 25,
        unlocked: false,
        unlockCost: 50,
        sprite: 'sawblade_sprite',
        muzzleFlash: 'flash_void',
        sound: 'sawblade_whirl'
    }),
    
    VOID_ORB: new Weapon({
        id: 'void_orb',
        name: 'Orbe del Vacío',
        description: 'Esfera de oscuridad concentrada. Atrae a los enemigos antes de explotar.',
        damage: 75,
        fireRate: 1500,
        reloadTime: 2000,
        magazineSize: 3,
        ammoType: AmmoType.ENERGY,
        damageType: DamageType.VOID,
        spread: 0.01,
        projectileSpeed: 10,
        explosionRadius: 5,
        unlocked: false,
        unlockCost: 60,
        sprite: 'void_orb_sprite',
        muzzleFlash: 'flash_dark',
        sound: 'void_whisper'
    }),
    
    BONE_CANNON: new Weapon({
        id: 'bone_cannon',
        name: 'Cañón de Hueso',
        description: 'Forjado con los restos de un santo. Penetra filas de enemigos.',
        damage: 200,
        fireRate: 2000,
        reloadTime: 3000,
        magazineSize: 1,
        ammoType: AmmoType.ROCKETS,
        spread: 0.005,
        recoil: 0.8,
        unlocked: false,
        unlockCost: 75,
        sprite: 'bone_cannon_sprite',
        muzzleFlash: 'flash_holy',
        sound: 'bone_cannon_roar'
    }),
    
    // ============ ARMA LEGENDARIA ============
    
    LAST_WORD: new Weapon({
        id: 'last_word',
        name: 'La Última Palabra',
        description: 'Un solo uso. Una sola palabra. Silencio absoluto.',
        damage: 9999,
        fireRate: 0,
        reloadTime: 0,
        magazineSize: 1,
        ammoType: AmmoType.INFINITE,
        damageType: DamageType.VOID,
        spread: 0,
        unlocked: false,
        unlockCost: 100,
        sprite: 'last_word_sprite',
        muzzleFlash: 'flash_apocalypse',
        sound: 'last_word_silence'
    })
};

// ============================================
// SISTEMA DE MODIFICADORES
// ============================================

const WeaponModifiers = {
    // Comunes
    DAMAGE_25: { id: 'damage_25', name: '+25% Daño', type: 'damage', value: 0.25, rarity: 'common' },
    FIRE_RATE_20: { id: 'fire_rate_20', name: '+20% Cadencia', type: 'fireRate', value: 0.20, rarity: 'common' },
    MAGAZINE_50: { id: 'magazine_50', name: '+50% Cargador', type: 'magazine', value: 0.50, rarity: 'common' },
    
    // Raros
    BOUNCE_1: { id: 'bounce_1', name: 'Proyectiles Rebotan', type: 'bounce', value: 1, rarity: 'rare' },
    PIERCE_2: { id: 'pierce_2', name: 'Penetración +2', type: 'pierce', value: 2, rarity: 'rare' },
    VAMPIRIC_5: { id: 'vampiric_5', name: 'Vampírico 5%', type: 'vampiric', value: 0.05, rarity: 'rare' },
    
    // Épicos
    EXPLOSIVE_3: { id: 'explosive_3', name: 'Impactos Explosivos', type: 'explosive', value: 3, rarity: 'epic' },
    DOUBLE_SHOT: { id: 'double_shot', name: 'Doble Disparo', type: 'pellets', value: 1, rarity: 'epic' },
    VOID_TOUCHED: { id: 'void_touched', name: 'Toque del Vacío', type: 'damageType', value: DamageType.VOID, rarity: 'epic' },
    
    // Legendarios
    TIME_SLOW: { id: 'time_slow', name: 'Tiempo del Cazador', type: 'timeSlow', value: 0.3, rarity: 'legendary' },
    INFINITE_AMMO: { id: 'infinite_ammo', name: 'Munición Infinita', type: 'infiniteAmmo', value: true, rarity: 'legendary' }
};

// ============================================
// GESTOR DE ARMAS
// ============================================

class WeaponManager {
    constructor() {
        this.unlockedWeapons = ['pistol']; // Pistola siempre desbloqueada
        this.currentWeaponIndex = 0;
        this.weapons = [WEAPONS.PISTOL];
        this.souls = 0; // Moneda meta
    }
    
    /**
     * Desbloquea un arma con almas
     */
    unlockWeapon(weaponId) {
        const weapon = WEAPONS[weaponId.toUpperCase()];
        if (!weapon) return false;
        if (this.unlockedWeapons.includes(weaponId)) return false;
        if (this.souls < weapon.unlockCost) return false;
        
        this.souls -= weapon.unlockCost;
        this.unlockedWeapons.push(weaponId);
        return true;
    }
    
    /**
     * Añade un arma al inventario actual
     */
    addWeapon(weaponId) {
        if (!this.unlockedWeapons.includes(weaponId)) return false;
        if (this.weapons.length >= 4) return false; // Máximo 4 armas
        
        const weapon = WEAPONS[weaponId.toUpperCase()];
        this.weapons.push(weapon);
        return true;
    }
    
    /**
     * Cambia al arma siguiente
     */
    nextWeapon() {
        this.currentWeaponIndex = (this.currentWeaponIndex + 1) % this.weapons.length;
        return this.getCurrentWeapon();
    }
    
    /**
     * Cambia al arma anterior
     */
    previousWeapon() {
        this.currentWeaponIndex = (this.currentWeaponIndex - 1 + this.weapons.length) % this.weapons.length;
        return this.getCurrentWeapon();
    }
    
    /**
     * Obtiene el arma actual
     */
    getCurrentWeapon() {
        return this.weapons[this.currentWeaponIndex];
    }
    
    /**
     * Serialización para guardado
     */
    serialize() {
        return {
            unlockedWeapons: this.unlockedWeapons,
            currentWeaponIndex: this.currentWeaponIndex,
            weapons: this.weapons.map(w => w.serialize()),
            souls: this.souls
        };
    }
    
    /**
     * Carga desde guardado
     */
    deserialize(data) {
        this.unlockedWeapons = data.unlockedWeapons;
        this.currentWeaponIndex = data.currentWeaponIndex;
        this.souls = data.souls;
        
        // Reconstruir armas
        this.weapons = data.weapons.map(w => {
            const weapon = new Weapon(WEAPONS[w.id.toUpperCase()]);
            weapon.currentAmmo = w.currentAmmo;
            weapon.reserveAmmo = w.reserveAmmo;
            weapon.modifiers = w.modifiers;
            return weapon;
        });
    }
}

// Exportar
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        Weapon,
        WEAPONS,
        WeaponModifiers,
        WeaponManager,
        AmmoType,
        DamageType
    };
}
