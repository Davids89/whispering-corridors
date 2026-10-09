extends Node2D
class_name BillboardSprite

## BillboardSprite - Sprite que siempre mira a la cámara (estilo Doom)
## Se usa para enemigos, items, y objetos del mundo

# Configuración
@export var sprite_texture: Texture2D = null
@export var sprite_scale: float = 1.0
@export var y_offset: float = 0.0  # Offset vertical (para sprites que flotan)

# Referencias
var player: Node2D = null
var raycast_renderer: RaycastRenderer = null

# Estado
var world_position: Vector2 = Vector2.ZERO
var distance_to_player: float = 0.0
var screen_position: Vector2 = Vector2.ZERO
var sprite_height: float = 0.0
var is_visible: bool = false

# Animación (opcional)
var animation_frames: Array[Texture2D] = []
var current_frame: int = 0
var animation_speed: float = 0.1
var animation_timer: float = 0.0

func _ready() -> void:
	# Buscar referencias
	call_deferred("_find_references")

func _find_references() -> void:
	"""Encuentra las referencias necesarias"""
	# Buscar jugador
	player = get_tree().get_first_node_in_group("player")
	
	# Buscar renderer
	raycast_renderer = get_tree().get_first_node_in_group("raycast_renderer")
	
	if player and raycast_renderer:
		print("BillboardSprite inicializado: ", name)
	else:
		push_warning("BillboardSprite: No se encontraron referencias")

func _process(delta: float) -> void:
	if player == null or raycast_renderer == null:
		return
	
	# Actualizar posición en mundo
	world_position = global_position
	
	# Calcular distancia al jugador
	distance_to_player = world_position.distance_to(player.global_position)
	
	# Verificar si está en el campo de visión
	_update_visibility()
	
	# Actualizar animación
	if animation_frames.size() > 1:
		animation_timer += delta
		if animation_timer >= animation_speed:
			animation_timer = 0.0
			current_frame = (current_frame + 1) % animation_frames.size()
			sprite_texture = animation_frames[current_frame]

func _update_visibility() -> void:
	"""Actualiza si el sprite es visible y su posición en pantalla"""
	# Convertir posición del mundo a pantalla
	screen_position = raycast_renderer.world_to_screen(world_position)
	
	# Verificar si está en pantalla
	is_visible = (
		screen_position.x >= -100 and 
		screen_position.x <= raycast_renderer.SCREEN_WIDTH + 100 and
		screen_position.y >= 0  # No está detrás de la cámara
	)
	
	# Calcular altura del sprite en pantalla
	if distance_to_player > 0:
		sprite_height = raycast_renderer.SCREEN_HEIGHT / distance_to_player
	else:
		sprite_height = raycast_renderer.SCREEN_HEIGHT
	
	# Aplicar escala
	sprite_height *= sprite_scale

func _draw() -> void:
	if not is_visible or sprite_texture == null:
		return
	
	# Verificar z-buffer (oclusión por paredes)
	var z_buffer = raycast_renderer.get_z_buffer()
	var buffer_index = int(screen_position.x / (raycast_renderer.SCREEN_WIDTH / raycast_renderer.NUM_RAYS))
	buffer_index = clamp(buffer_index, 0, z_buffer.size() - 1)
	
	if buffer_index < z_buffer.size():
		var wall_distance = z_buffer[buffer_index]
		if distance_to_player > wall_distance:
			return  # La pared está más cerca, no dibujar
	
	# Calcular posición y tamaño
	var draw_x = screen_position.x - sprite_height / 2
	var draw_y = raycast_renderer.SCREEN_HEIGHT / 2 - sprite_height / 2 + y_offset
	
	# Dibujar sprite
	draw_texture_rect(
		sprite_texture,
		Rect2(draw_x, draw_y, sprite_height, sprite_height),
		false
	)

func set_animation_frames(frames: Array[Texture2D], speed: float = 0.1) -> void:
	"""Establece los frames de animación"""
	animation_frames = frames
	animation_speed = speed
	current_frame = 0
	if frames.size() > 0:
		sprite_texture = frames[0]

func set_texture(texture: Texture2D) -> void:
	"""Establece la textura del sprite"""
	sprite_texture = texture
	animation_frames.clear()  # Desactivar animación
