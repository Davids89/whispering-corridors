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

func _ready() -> void:
	print("TestLevel inicializado")
	
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
	
	# Capturar mouse
	InputManager.capture_mouse()

func _input(event: InputEvent) -> void:
	# ESC para liberar mouse
	if event.is_action_pressed("pause"):
		InputManager.toggle_mouse_capture()
