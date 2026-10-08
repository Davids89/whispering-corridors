extends CharacterBody2D
class_name Player

## Player - Controlador del jugador para el sistema raycasting
## Maneja: movimiento, rotación, colisiones

# Configuración de movimiento
@export var move_speed: float = 4.0
@export var rotation_speed: float = 3.0

# Referencias
@onready var collision: CollisionShape2D = $CollisionShape2D

# Estado
var health: int = 100
var armor: int = 0
var current_weapon: int = 0

# Input
var input_vector: Vector2 = Vector2.ZERO
var mouse_delta: float = 0.0

func _ready() -> void:
	print("Player inicializado en posición: ", global_position)

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_rotation(delta)

func _handle_movement(delta: float) -> void:
	"""Maneja el movimiento WASD"""
	# Obtener input
	input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_backward"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	
	# Normalizar para movimiento diagonal consistente
	input_vector = input_vector.normalized()
	
	# Rotar el vector de movimiento según la dirección del jugador
	var rotated_input = input_vector.rotated(rotation)
	
	# Aplicar movimiento
	velocity = rotated_input * move_speed
	
	# Mover con colisiones
	move_and_slide()

func _handle_rotation(delta: float) -> void:
	"""Maneja la rotación con el mouse"""
	# La rotación se maneja en _input con mouse motion
	pass

func _input(event: InputEvent) -> void:
	"""Maneja input de mouse para rotación"""
	if event is InputEventMouseMotion:
		# Rotar según el movimiento horizontal del mouse
		rotation += event.relative.x * InputManager.mouse_sensitivity

func take_damage(amount: int) -> void:
	"""Aplica daño al jugador"""
	# Primero absorbe la armadura
	if armor > 0:
		var absorbed = min(armor, amount / 2)
		armor -= absorbed
		amount -= absorbed
	
	health -= amount
	health = max(0, health)
	
	print("Jugador recibió %d de daño. Salud: %d, Armadura: %d" % [amount, health, armor])
	
	if health <= 0:
		die()

func heal(amount: int) -> void:
	"""Cura al jugador"""
	health = min(health + amount, GameManager.player_max_health)
	print("Jugador curado. Salud: %d" % health)

func add_armor(amount: int) -> void:
	"""Añade armadura"""
	armor = min(armor + amount, 100)
	print("Armadura añadida: %d" % armor)

func die() -> void:
	"""Maneja la muerte del jugador"""
	print("¡Jugador muerto!")
	GameManager.player_die()

func get_forward_direction() -> Vector2:
	"""Retorna la dirección hacia adelante del jugador"""
	return Vector2(cos(rotation), sin(rotation))
