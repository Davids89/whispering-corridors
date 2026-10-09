extends Node2D
class_name TestLevel

## TestLevel - Nivel de prueba para el sistema raycasting
## Genera un mapa simple y configura el renderer

# Mapa del nivel (0 = vacío, 1 = piedra, 2 = metal, 3 = warp, 4 = puerta)
var level_map: Array = [
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,1,1,1,1,1,0,0,0,2,2,2,2,0,0,0,3,3,3,0,0,1],
	[1,0,0,1,0,0,0,1,0,0,0,2,0,0,2,0,0,0,3,0,3,0,0,1],
	[1,0,0,1,0,0,0,1,0,0,0,2,0,0,2,0,0,0,3,0,3,0,0,1],
	[1,0,0,1,0,0,0,1,0,0,0,2,2,4,2,0,0,0,3,3,3,0,0,1],
	[1,0,0,1,1,4,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,2,2,2,2,2,2,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1],
	[1,0,0,2,0,0,0,0,2,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1],
	[1,0,0,2,0,0,0,0,2,0,0,0,0,0,0,0,0,4,0,0,0,1,0,1],
	[1,0,0,2,0,0,0,0,2,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1],
	[1,0,0,2,2,2,4,2,2,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,3,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,3,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
]

# Referencias
@onready var raycast_renderer: RaycastRenderer = $RaycastRenderer
@onready var player: Player = $Player

# Escenas
var enemy_scene = preload("res://scenes/enemies/Enemy.tscn")

func _ready() -> void:
	print("TestLevel inicializado")
	
	# Configurar grupos
	_setup_groups()
	
	# Configurar el renderer con el mapa
	if raycast_renderer:
		raycast_renderer.set_map(level_map)
		print("Mapa asignado al renderer")
	
	# Configurar el jugador
	if player:
		# Posición inicial del jugador (centro del mapa)
		player.global_position = Vector2(12, 12)
		player.rotation = 0  # Mirando hacia la derecha
		
		# Asignar jugador al renderer
		if raycast_renderer:
			raycast_renderer.set_player(player)
			print("Jugador asignado al renderer")
	
	# Spawnear enemigos de prueba
	_spawn_test_enemies()
	
	# Capturar mouse
	InputManager.capture_mouse()

func _setup_groups() -> void:
	"""Configura los grupos para búsqueda de referencias"""
	if player:
		player.add_to_group("player")
	if raycast_renderer:
		raycast_renderer.add_to_group("raycast_renderer")

func _spawn_test_enemies() -> void:
	"""Spawnea enemigos de prueba en el nivel"""
	var spawn_points = [
		Vector2(8, 8),
		Vector2(16, 8),
		Vector2(8, 16),
		Vector2(16, 16),
		Vector2(20, 12)
	]
	
	for i, pos in enumerate(spawn_points):
		var enemy = enemy_scene.instantiate()
		enemy.global_position = pos
		enemy.enemy_name = "Cultista_" + str(i + 1)
		add_child(enemy)
		print("Enemigo spawneado en: ", pos)

func _input(event: InputEvent) -> void:
	# ESC para liberar mouse
	if event.is_action_pressed("pause"):
		InputManager.toggle_mouse_capture()
