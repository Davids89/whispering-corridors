extends Node

## InputManager - Singleton para gestión de entrada
## Maneja: configuración de controles, sensibilidad, rebinding

signal input_scheme_changed

# Configuración de sensibilidad
var mouse_sensitivity: float = 0.002
var mouse_invert_y: bool = false

# Estado de captura del mouse
var mouse_captured: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("InputManager inicializado")

func _input(event: InputEvent) -> void:
	# Capturar/liberar mouse con ESC
	if event.is_action_pressed("pause"):
		toggle_mouse_capture()

func toggle_mouse_capture() -> void:
	if mouse_captured:
		release_mouse()
	else:
		capture_mouse()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func get_movement_vector() -> Vector2:
	"""Retorna el vector de movimiento normalizado"""
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_backward"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	
	return input_vector.normalized()

func get_mouse_delta(event: InputEventMouseMotion) -> Vector2:
	"""Retorna el delta del mouse aplicando sensibilidad"""
	var delta = event.relative * mouse_sensitivity
	if mouse_invert_y:
		delta.y = -delta.y
	return delta

func set_sensitivity(value: float) -> void:
	mouse_sensitivity = clamp(value, 0.0001, 0.01)
	input_scheme_changed.emit()

func set_invert_y(value: bool) -> void:
	mouse_invert_y = value
	input_scheme_changed.emit()
