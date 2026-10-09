extends Node2D
class_name Enemy

## Enemy - Enemigo base con sprite billboard
## Hereda de BillboardSprite para renderizado 2.5D

# Señales
signal died(enemy)
signal damaged(amount)

# Configuración
@export var enemy_name: String = "Cultista"
@export var max_health: int = 50
@export var move_speed: float = 2.0
@export var attack_damage: int = 10
@export var attack_range: float = 1.5
@export var attack_cooldown: float = 1.0
@export var souls_reward: int = 10

# Estado
var health: int = 0
var is_dead: bool = false
var is_attacking: bool = false
var attack_timer: float = 0.0

# Referencias
@onready var billboard: BillboardSprite = $BillboardSprite
@onready var collision: CollisionShape2D = $CollisionShape2D

# IA
var player: Node2D = null
var state: String = "idle"  # idle, chase, attack, dead

func _ready() -> void:
	health = max_health
	
	# Añadir al grupo de enemigos
	add_to_group("enemies")
	
	# Buscar jugador
	player = get_tree().get_first_node_in_group("player")
	
	print("Enemy inicializado: ", enemy_name)

func _physics_process(delta: float) -> void:
	if is_dead or player == null:
		return
	
	# Actualizar cooldown de ataque
	if attack_timer > 0:
		attack_timer -= delta
	
	# Máquina de estados simple
	match state:
		"idle":
			_state_idle(delta)
		"chase":
			_state_chase(delta)
		"attack":
			_state_attack(delta)

func _state_idle(_delta: float) -> void:
	"""Estado idle: esperar a que el jugador esté cerca"""
	var distance = global_position.distance_to(player.global_position)
	
	if distance < 10.0:  # Rango de detección
		state = "chase"
		print(enemy_name, " ha detectado al jugador!")

func _state_chase(delta: float) -> void:
	"""Estado chase: perseguir al jugador"""
	var direction = (player.global_position - global_position).normalized()
	var distance = global_position.distance_to(player.global_position)
	
	# Mover hacia el jugador
	if distance > attack_range:
		global_position += direction * move_speed * delta
	else:
		# En rango de ataque
		state = "attack"
		is_attacking = true

func _state_attack(_delta: float) -> void:
	"""Estado attack: atacar al jugador"""
	var distance = global_position.distance_to(player.global_position)
	
	# Si el jugador se aleja, volver a perseguir
	if distance > attack_range * 1.5:
		state = "chase"
		is_attacking = false
		return
	
	# Atacar si el cooldown está listo
	if attack_timer <= 0:
		_perform_attack()
		attack_timer = attack_cooldown

func _perform_attack() -> void:
	"""Realiza un ataque al jugador"""
	if player.has_method("take_damage"):
		player.take_damage(attack_damage)
		print(enemy_name, " ataca! Daño: ", attack_damage)
		
		# Efecto visual de ataque (opcional)
		_play_attack_animation()

func _play_attack_animation() -> void:
	"""Reproduce la animación de ataque"""
	# TODO: Implementar animación de ataque
	pass

func take_damage(amount: int) -> void:
	"""Recibe daño"""
	if is_dead:
		return
	
	health -= amount
	health = max(0, health)
	
	damaged.emit(amount)
	print(enemy_name, " recibe ", amount, " de daño. Salud: ", health)
	
	# Efecto de daño (flash rojo)
	_play_damage_effect()
	
	if health <= 0:
		die()

func _play_damage_effect() -> void:
	"""Efecto visual al recibir daño"""
	# TODO: Implementar flash de daño
	pass

func die() -> void:
	"""Muerte del enemigo"""
	is_dead = true
	state = "dead"
	
	print(enemy_name, " ha muerto!")
	
	# Dar almas al jugador
	if GameManager:
		GameManager.add_souls(souls_reward)
	
	died.emit(self)
	
	# Desactivar colisión
	if collision:
		collision.set_deferred("disabled", true)
	
	# Ocultar sprite
	if billboard:
		billboard.visible = false
	
	# Eliminar después de un tiempo
	await get_tree().create_timer(2.0).timeout
	queue_free()

func set_sprite_texture(texture: Texture2D) -> void:
	"""Establece la textura del sprite"""
	if billboard:
		billboard.set_texture(texture)

func set_animation_frames(frames: Array[Texture2D], speed: float = 0.1) -> void:
	"""Establece los frames de animación"""
	if billboard:
		billboard.set_animation_frames(frames, speed)
