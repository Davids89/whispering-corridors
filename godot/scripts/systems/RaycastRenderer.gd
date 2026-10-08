extends Node2D
class_name RaycastRenderer

## RaycastRenderer - Motor de renderizado 2.5D estilo Wolfenstein 3D
## Genera la vista en primera persona usando raycasting sobre un mapa 2D

# Configuración de renderizado
const SCREEN_WIDTH: int = 640
const SCREEN_HEIGHT: int = 360
const NUM_RAYS: int = 320  # 2 píxeles por rayo
const FOV: float = 66.0    # Campo de visión en grados
const MAX_DEPTH: float = 20.0
const WALL_HEIGHT: float = 1.0

# Referencias
var player: Node2D = null
var world_map: Array = []
var map_width: int = 0
var map_height: int = 0

# Texturas procedurales
var wall_textures: Array[Image] = []
var texture_size: int = 64

# Buffer de profundidad para sprites
var z_buffer: PackedFloat32Array = []

# Colores base (paleta lovecraftiana)
const COLOR_SKY_TOP: Color = Color(0.04, 0.02, 0.06)      # Azul muy oscuro
const COLOR_SKY_BOTTOM: Color = Color(0.10, 0.05, 0.16)   # Púrpura oscuro
const COLOR_FLOOR_TOP: Color = Color(0.10, 0.08, 0.06)    # Marrón oscuro
const COLOR_FLOOR_BOTTOM: Color = Color(0.04, 0.03, 0.02) # Casi negro

# Tipos de pared
enum WallType {
	EMPTY = 0,
	STONE = 1,      # Piedra gris
	METAL = 2,      # Metal oxidado
	WARP = 3,       # Energía warp (verde)
	DOOR = 4        # Puerta
}

# Colores de pared por tipo (para fallback sin texturas)
const WALL_COLORS: Dictionary = {
	WallType.STONE: Color(0.35, 0.32, 0.30),
	WallType.METAL: Color(0.45, 0.28, 0.15),
	WallType.WARP: Color(0.15, 0.75, 0.35),
	WallType.DOOR: Color(0.55, 0.35, 0.20)
}

# Eficiencia: solo re-renderizar cuando sea necesario
var needs_redraw: bool = true
var last_player_pos: Vector2 = Vector2.ZERO
var last_player_angle: float = 0.0

func _ready() -> void:
	# Inicializar z-buffer
	z_buffer.resize(NUM_RAYS)
	
	# Generar texturas procedurales
	_generate_wall_textures()
	
	print("RaycastRenderer inicializado: %d rayos, FOV %.0f°" % [NUM_RAYS, FOV])

func _generate_wall_textures() -> void:
	"""Genera texturas procedurales para las paredes"""
	wall_textures.clear()
	
	# Textura 1: Piedra
	var stone = _create_stone_texture()
	wall_textures.append(stone)
	
	# Textura 2: Metal oxidado
	var metal = _create_metal_texture()
	wall_textures.append(metal)
	
	# Textura 3: Energía warp
	var warp = _create_warp_texture()
	wall_textures.append(warp)
	
	# Textura 4: Puerta
	var door = _create_door_texture()
	wall_textures.append(door)
	
	print("Generadas %d texturas de pared" % wall_textures.size())

func _create_stone_texture() -> Image:
	"""Crea textura de piedra procedural"""
	var img = Image.create(texture_size, texture_size, false, Image.FORMAT_RGB8)
	
	for y in texture_size:
		for x in texture_size:
			# Patrón de ladrillos
			var brick_x = (x / 16) % 2
			var brick_y = (y / 8) % 2
			var offset = brick_y * 8
			var in_mortar = (x + offset) % 16 < 2 or y % 8 < 1
			
			var base_color = 0.25 + randf() * 0.1
			var color: Color
			
			if in_mortar:
				color = Color(base_color * 0.6, base_color * 0.55, base_color * 0.5)
			else:
				var noise = randf() * 0.15
				color = Color(base_color + noise, base_color * 0.9 + noise, base_color * 0.8 + noise)
			
			img.set_pixel(x, y, color)
	
	return img

func _create_metal_texture() -> Image:
	"""Crea textura de metal oxidado"""
	var img = Image.create(texture_size, texture_size, false, Image.FORMAT_RGB8)
	
	for y in texture_size:
		for x in texture_size:
			# Paneles metálicos
			var panel_x = (x / 32) % 2
			var panel_y = (y / 32) % 2
			var rivet = ((x % 32) < 4 or (x % 32) > 28) and ((y % 32) < 4 or (y % 32) > 28)
			
			var rust = randf() * 0.3
			var base = 0.35 + randf() * 0.1
			
			var color: Color
			if rivet:
				color = Color(base * 0.5, base * 0.4, base * 0.3)
			else:
				# Óxido naranja-marrón
				color = Color(base + rust * 0.3, base * 0.7 + rust * 0.1, base * 0.4)
			
			img.set_pixel(x, y, color)
	
	return img

func _create_warp_texture() -> Image:
	"""Crea textura de energía warp (verde espectral)"""
	var img = Image.create(texture_size, texture_size, false, Image.FORMAT_RGB8)
	
	for y in texture_size:
		for x in texture_size:
			# Patrón de energía ondulante
			var wave1 = sin(x * 0.3 + y * 0.2) * 0.5 + 0.5
			var wave2 = sin(x * 0.15 - y * 0.25) * 0.5 + 0.5
			var energy = (wave1 + wave2) * 0.5
			
			var glow = randf() * 0.2
			var intensity = 0.2 + energy * 0.5 + glow
			
			# Verde espectral lovecraftiano
			var color = Color(
				intensity * 0.2,
				intensity * 0.9,
				intensity * 0.4
			)
			
			img.set_pixel(x, y, color)
	
	return img

func _create_door_texture() -> Image:
	"""Crea textura de puerta"""
	var img = Image.create(texture_size, texture_size, false, Image.FORMAT_RGB8)
	
	for y in texture_size:
		for x in texture_size:
			# Marco de puerta
			var frame = x < 4 or x > texture_size - 5 or y < 4 or y > texture_size - 5
			var panel = (x > 16 and x < 48) and ((y > 8 and y < 28) or (y > 36 and y < 56))
			
			var base = 0.4 + randf() * 0.1
			var color: Color
			
			if frame:
				color = Color(base * 0.5, base * 0.35, base * 0.2)
			elif panel:
				color = Color(base * 0.8, base * 0.6, base * 0.4)
			else:
				color = Color(base, base * 0.75, base * 0.5)
			
			img.set_pixel(x, y, color)
	
	return img

func set_map(map_data: Array) -> void:
	"""Establece el mapa del mundo"""
	world_map = map_data
	if world_map.size() > 0:
		map_height = world_map.size()
		map_width = world_map[0].size()
	needs_redraw = true
	print("Mapa establecido: %dx%d" % [map_width, map_height])

func set_player(p: Node2D) -> void:
	"""Establece la referencia al jugador"""
	player = p
	needs_redraw = true

func _process(_delta: float) -> void:
	if player == null:
		return
	
	# Verificar si necesitamos re-renderizar
	var pos_changed = player.global_position.distance_to(last_player_pos) > 0.01
	var angle_changed = abs(player.rotation - last_player_angle) > 0.001
	
	if pos_changed or angle_changed or needs_redraw:
		last_player_pos = player.global_position
		last_player_angle = player.rotation
		needs_redraw = false
		queue_redraw()

func _draw() -> void:
	if player == null or world_map.is_empty():
		return
	
	# Dibujar cielo y suelo
	_draw_sky_and_floor()
	
	# Dibujar paredes con raycasting
	_draw_walls()

func _draw_sky_and_floor() -> void:
	"""Dibuja el cielo y el suelo con gradientes"""
	var center = Vector2(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	
	# Cielo (mitad superior)
	for i in range(SCREEN_HEIGHT / 2):
		var t = float(i) / (SCREEN_HEIGHT / 2)
		var color = COLOR_SKY_TOP.lerp(COLOR_SKY_BOTTOM, t)
		draw_line(
			Vector2(0, i),
			Vector2(SCREEN_WIDTH, i),
			color
		)
	
	# Suelo (mitad inferior)
	for i in range(SCREEN_HEIGHT / 2, SCREEN_HEIGHT):
		var t = float(i - SCREEN_HEIGHT / 2) / (SCREEN_HEIGHT / 2)
		var color = COLOR_FLOOR_TOP.lerp(COLOR_FLOOR_BOTTOM, t)
		draw_line(
			Vector2(0, i),
			Vector2(SCREEN_WIDTH, i),
			color
		)

func _draw_walls() -> void:
	"""Renderiza las paredes usando raycasting"""
	var player_pos = player.global_position
	var player_angle = player.rotation
	
	# Dirección del jugador
	var dir = Vector2(cos(player_angle), sin(player_angle))
	# Plano de la cámara (perpendicular a la dirección)
	var plane = Vector2(-dir.y, dir.x) * tan(deg_to_rad(FOV) / 2)
	
	# Para cada columna de la pantalla
	for x in NUM_RAYS:
		# Calcular dirección del rayo
		var camera_x = 2.0 * x / NUM_RAYS - 1.0
		var ray_dir = dir + plane * camera_x
		
		# Ejecutar DDA (Digital Differential Analysis)
		var hit = _cast_ray(player_pos, ray_dir)
		
		if hit.hit:
			# Corrección de ojo de pez
			var perp_dist = hit.distance * cos(camera_x * deg_to_rad(FOV / 2))
			
			# Guardar en z-buffer para sprites
			z_buffer[x] = perp_dist
			
			# Calcular altura de la columna
			var line_height = SCREEN_HEIGHT / perp_dist if perp_dist > 0 else SCREEN_HEIGHT
			
			# Calcular inicio y fin de la columna
			var draw_start = -line_height / 2 + SCREEN_HEIGHT / 2
			var draw_end = line_height / 2 + SCREEN_HEIGHT / 2
			
			# Clamp a pantalla
			draw_start = max(0, draw_start)
			draw_end = min(SCREEN_HEIGHT - 1, draw_end)
			
			# Calcular coordenada de textura
			var tex_x = int(hit.texture_coord * texture_size)
			tex_x = clamp(tex_x, 0, texture_size - 1)
			
			# Obtener textura
			var tex_index = clamp(hit.wall_type - 1, 0, wall_textures.size() - 1)
			var texture = wall_textures[tex_index]
			
			# Calcular shading por distancia
			var shade = 1.0 - (perp_dist / MAX_DEPTH)
			shade = clamp(shade, 0.2, 1.0)
			
			# Dibujar columna de píxeles
			var screen_x = x * (SCREEN_WIDTH / NUM_RAYS)
			var col_width = SCREEN_WIDTH / NUM_RAYS + 1
			
			for y in range(int(draw_start), int(draw_end)):
				# Coordenada Y de textura
				var tex_y = int(((y - draw_start) / (draw_end - draw_start)) * texture_size)
				tex_y = clamp(tex_y, 0, texture_size - 1)
				
				# Obtener color de textura
				var color = texture.get_pixel(tex_x, tex_y)
				
				# Aplicar shading
				color = color * shade
				
				# Dibujar píxel (o rectángulo de 2px de ancho)
				draw_rect(
					Rect2(screen_x, y, col_width, 1),
					color
				)

func _cast_ray(origin: Vector2, direction: Vector2) -> Dictionary:
	"""Lanza un rayo y retorna información de colisión usando DDA"""
	var result = {
		"hit": false,
		"distance": MAX_DEPTH,
		"wall_type": 0,
		"texture_coord": 0.0,
		"side": 0  # 0 = vertical, 1 = horizontal
	}
	
	# Posición en el mapa
	var map_x = int(origin.x)
	var map_y = int(origin.y)
	
	# Distancia entre intersecciones de grid
	var delta_dist_x = abs(1.0 / direction.x) if direction.x != 0 else 1e30
	var delta_dist_y = abs(1.0 / direction.y) if direction.y != 0 else 1e30
	
	# Dirección de paso y distancia inicial
	var step_x: int
	var step_y: int
	var side_dist_x: float
	var side_dist_y: float
	
	if direction.x < 0:
		step_x = -1
		side_dist_x = (origin.x - map_x) * delta_dist_x
	else:
		step_x = 1
		side_dist_x = (map_x + 1.0 - origin.x) * delta_dist_x
	
	if direction.y < 0:
		step_y = -1
		side_dist_y = (origin.y - map_y) * delta_dist_y
	else:
		step_y = 1
		side_dist_y = (map_y + 1.0 - origin.y) * delta_dist_y
	
	# DDA
	var hit = false
	var side = 0
	var max_steps = 100
	var steps = 0
	
	while not hit and steps < max_steps:
		# Saltar a la siguiente celda
		if side_dist_x < side_dist_y:
			side_dist_x += delta_dist_x
			map_x += step_x
			side = 0
		else:
			side_dist_y += delta_dist_y
			map_y += step_y
			side = 1
		
		# Verificar límites
		if map_x < 0 or map_x >= map_width or map_y < 0 or map_y >= map_height:
			break
		
		# Verificar colisión
		if world_map[map_y][map_x] > 0:
			hit = true
			result.hit = true
			result.wall_type = world_map[map_y][map_x]
			result.side = side
			
			# Calcular distancia perpendicular
			if side == 0:
				result.distance = (map_x - origin.x + (1 - step_x) / 2) / direction.x
			else:
				result.distance = (map_y - origin.y + (1 - step_y) / 2) / direction.y
			
			# Calcular coordenada de textura
			var wall_x: float
			if side == 0:
				wall_x = origin.y + result.distance * direction.y
			else:
				wall_x = origin.x + result.distance * direction.x
			wall_x -= floor(wall_x)
			result.texture_coord = wall_x
		
		steps += 1
	
	return result

func get_z_buffer() -> PackedFloat32Array:
	"""Retorna el z-buffer para renderizado de sprites"""
	return z_buffer

func world_to_screen(world_pos: Vector2) -> Vector2:
	"""Convierte posición del mundo a coordenadas de pantalla"""
	if player == null:
		return Vector2.ZERO
	
	var player_pos = player.global_position
	var player_angle = player.rotation
	
	# Vector relativo al jugador
	var rel_pos = world_pos - player_pos
	
	# Rotar al espacio de la cámara
	var cos_angle = cos(-player_angle)
	var sin_angle = sin(-player_angle)
	var cam_x = rel_pos.x * cos_angle - rel_pos.y * sin_angle
	var cam_y = rel_pos.x * sin_angle + rel_pos.y * cos_angle
	
	# Proyección
	if cam_y <= 0:
		return Vector2(-1000, -1000)  # Detrás de la cámara
	
	var screen_x = SCREEN_WIDTH / 2 + (cam_x / cam_y) * (SCREEN_WIDTH / 2) / tan(deg_to_rad(FOV / 2))
	var screen_y = SCREEN_HEIGHT / 2  # Centro vertical
	
	return Vector2(screen_x, screen_y)
