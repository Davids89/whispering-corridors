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
	
	# Conectar señales
	GameManager.game_paused.connect(_on_game_paused)
	GameManager.game_resumed.connect(_on_game_resumed)
	
	# Iniciar en modo debug si está habilitado
	if OS.is_debug_build():
		debug_mode = true
		debug_info.visible = true
	
	# Capturar mouse
	InputManager.capture_mouse()
	
	# Cargar nivel inicial (temporal)
	_load_test_level()

func _process(_delta: float) -> void:
	if debug_mode:
		_update_debug_info()

func _input(event: InputEvent) -> void:
	# Toggle debug con F3
	if event.is_action_pressed("ui_text_completion_accept") or (event is InputEventKey and event.keycode == KEY_F3 and event.pressed):
		debug_mode = !debug_mode
		debug_info.visible = debug_mode

func _load_test_level() -> void:
	"""Carga un nivel de prueba (temporal)"""
	# TODO: Implementar carga de niveles
	print("Cargando nivel de prueba...")
	
	# Por ahora, solo mostrar mensaje
	var label = Label.new()
	label.text = "WHISPERING CORRIDORS\n\nProyecto Godot 4 inicializado\n\nPresiona F3 para debug"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.anchors_preset = Control.PRESET_CENTER
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color(0.79, 0.64, 0.15))  # Dorado
	hud.add_child(label)

func _update_debug_info() -> void:
	"""Actualiza la información de debug"""
	var fps = Engine.get_frames_per_second()
	var state = GameManager.GameState.keys()[GameManager.current_state]
	var mouse_pos = get_global_mouse_position()
	
	debug_info.text = "FPS: %d\nEstado: %s\nMouse: (%.0f, %.0f)\nSalud: %d\nAlmas: %d" % [
		fps,
		state,
		mouse_pos.x,
		mouse_pos.y,
		GameManager.player_health,
		GameManager.player_souls
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
		GameManager.current_level = level_path
	else:
		push_error("No se pudo cargar el nivel: " + level_path)
