extends Node2D

## Main - Escena principal del juego
## Maneja: inicialización, cambio de escenas, debug

@onready var world: Node2D = $World
@onready var ui: CanvasLayer = $UI
@onready var hud: Control = $UI/HUD
@onready var debug_info: Label = $UI/HUD/DebugInfo

var current_level: Node = null
var debug_mode: bool = false

func _ready() -> void:
	print("Main inicializado")
	
	# Conectar señales (con verificación de que existen los autoloads)
	if has_node("/root/GameManager"):
		GameManager.game_paused.connect(_on_game_paused)
		GameManager.game_resumed.connect(_on_game_resumed)
		print("GameManager conectado")
	else:
		push_warning("GameManager no encontrado")
	
	# Iniciar en modo debug si está habilitado
	if OS.is_debug_build():
		debug_mode = true
		debug_info.visible = true
	
	# Capturar mouse (con verificación)
	if has_node("/root/InputManager"):
		InputManager.capture_mouse()
		print("InputManager conectado")
	else:
		push_warning("InputManager no encontrado")

func _process(_delta: float) -> void:
	if debug_mode:
		_update_debug_info()

func _input(event: InputEvent) -> void:
	# Toggle debug con F3
	if event is InputEventKey and event.keycode == KEY_F3 and event.pressed:
		debug_mode = !debug_mode
		debug_info.visible = debug_mode
		print("Debug mode: ", debug_mode)

func _update_debug_info() -> void:
	"""Actualiza la información de debug"""
	var fps = Engine.get_frames_per_second()
	var state = "N/A"
	var health = 0
	var souls = 0
	
	if has_node("/root/GameManager"):
		state = GameManager.GameState.keys()[GameManager.current_state]
		health = GameManager.player_health
		souls = GameManager.player_souls
	
	var mouse_pos = get_global_mouse_position()
	
	debug_info.text = "FPS: %d\nEstado: %s\nMouse: (%.0f, %.0f)\nSalud: %d\nAlmas: %d" % [
		fps,
		state,
		mouse_pos.x,
		mouse_pos.y,
		health,
		souls
	]

func _on_game_paused() -> void:
	print("Juego pausado")

func _on_game_resumed() -> void:
	print("Juego reanudado")

func change_level(level_path: String) -> void:
	"""Cambia a un nuevo nivel"""
	if current_level:
		current_level.queue_free()
	
	var level_scene = load(level_path)
	if level_scene:
		current_level = level_scene.instantiate()
		world.add_child(current_level)
		if has_node("/root/GameManager"):
			GameManager.current_level = level_path
	else:
		push_error("No se pudo cargar el nivel: " + level_path)
