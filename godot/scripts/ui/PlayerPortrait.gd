extends Control
class_name PlayerPortrait

## PlayerPortrait - Retrato del personaje con estados de daño
## Muestra la cara del personaje que se deteriora con el daño

# Estados de daño
enum DamageState {
	HEALTHY,    # 100-80%
	WORRIED,    # 79-60%
	HURT,       # 59-40%
	BADLY_HURT, # 39-20%
	CRITICAL    # 19-0%
}

# Configuración
@export var portrait_size: Vector2 = Vector2(64, 64)

# Referencias
@onready var portrait_rect: TextureRect = $PortraitRect
@onready var damage_overlay: ColorRect = $DamageOverlay

# Estado actual
var current_state: DamageState = DamageState.HEALTHY
var current_health_percent: float = 100.0

# Texturas de retrato (placeholder - serán reemplazadas por sprites de Pixel Pete)
var portrait_textures: Array[ImageTexture] = []

# Colores para placeholder
const SKIN_COLOR: Color = Color(0.85, 0.75, 0.65)  # Piel pálida
const SKIN_SHADOW: Color = Color(0.65, 0.55, 0.45)
const BLOOD_COLOR: Color = Color(0.6, 0.1, 0.1)    # Sangre oscura
const EYE_COLOR: Color = Color(0.2, 0.15, 0.1)     # Ojos oscuros
const WARP_TINT: Color = Color(0.2, 0.8, 0.4)      # Tinte warp (corrupción)

func _ready() -> void:
	# Generar texturas placeholder
	_generate_placeholder_portraits()
	
	# Configurar tamaño
	custom_minimum_size = portrait_size
	
	# Estado inicial
	update_health(100)
	
	print("PlayerPortrait inicializado")

func _generate_placeholder_portraits() -> void:
	"""Genera texturas placeholder para cada estado de daño"""
	portrait_textures.clear()
	
	for state in DamageState.values():
		var img = _create_portrait_image(state)
		var tex = ImageTexture.create_from_image(img)
		portrait_textures.append(tex)
	
	print("Generados %d retratos placeholder" % portrait_textures.size())

func _create_portrait_image(state: DamageState) -> Image:
	"""Crea una imagen de retrato placeholder para un estado"""
	var img = Image.create(64, 64, true, Image.FORMAT_RGBA8)
	
	# Fondo transparente
	img.fill(Color(0, 0, 0, 0))
	
	# Dibujar cara base
	_draw_face_base(img)
	
	# Aplicar efectos según estado
	match state:
		DamageState.HEALTHY:
			_draw_healthy(img)
		DamageState.WORRIED:
			_draw_worried(img)
		DamageState.HURT:
			_draw_hurt(img)
		DamageState.BADLY_HURT:
			_draw_badly_hurt(img)
		DamageState.CRITICAL:
			_draw_critical(img)
	
	return img

func _draw_face_base(img: Image) -> void:
	"""Dibuja la base de la cara"""
	# Cabeza (óvalo)
	for y in range(10, 54):
		for x in range(12, 52):
			var dx = (x - 32) / 20.0
			var dy = (y - 32) / 22.0
			if dx*dx + dy*dy <= 1.0:
				# Sombreado básico
				var shade = 1.0 - (dx * 0.3 + dy * 0.2)
				var color = SKIN_COLOR * shade
				img.set_pixel(x, y, color)
	
	# Ojos
	_draw_eye(img, 24, 28, false)  # Ojo izquierdo
	_draw_eye(img, 40, 28, false)  # Ojo derecho
	
	# Ceño
	for x in range(20, 44):
		for y in range(22, 26):
			if img.get_pixel(x, y).a > 0:
				img.set_pixel(x, y, SKIN_SHADOW)
	
	# Nariz (línea simple)
	for y in range(32, 40):
		img.set_pixel(32, y, SKIN_SHADOW)
	
	# Boca (línea neutral)
	for x in range(26, 38):
		img.set_pixel(x, 46, SKIN_SHADOW)

func _draw_eye(img: Image, cx: int, cy: int, bloodshot: bool) -> void:
	"""Dibuja un ojo"""
	for y in range(cy - 3, cy + 4):
		for x in range(cx - 4, cx + 5):
			var dx = (x - cx) / 4.0
			var dy = (y - cy) / 3.0
			if dx*dx + dy*dy <= 1.0:
				var color = EYE_COLOR
				if bloodshot:
					# Ojos inyectados en sangre
					if randf() > 0.7:
						color = BLOOD_COLOR
				img.set_pixel(x, y, color)

func _draw_healthy(img: Image) -> void:
	"""Estado saludable - expresión determinada"""
	# Sin modificaciones adicionales
	pass

func _draw_worried(img: Image) -> void:
	"""Estado preocupado - ceño fruncido"""
	# Arrugar ceño
	for x in range(22, 42):
		for y in range(20, 24):
			if img.get_pixel(x, y).a > 0:
				var current = img.get_pixel(x, y)
				img.set_pixel(x, y, current.darkened(0.2))
	
	# Ojos ligeramente más cerrados
	_draw_eye(img, 24, 29, false)
	_draw_eye(img, 40, 29, false)

func _draw_hurt(img: Image) -> void:
	"""Estado herido - sangre en ceño y mejilla"""
	# Sangre en ceño izquierdo
	for y in range(20, 32):
		for x in range(18, 26):
			if randf() > 0.5 and img.get_pixel(x, y).a > 0:
				img.set_pixel(x, y, BLOOD_COLOR)
	
	# Sangre en mejilla derecha
	for y in range(30, 42):
		for x in range(42, 50):
			if randf() > 0.6 and img.get_pixel(x, y).a > 0:
				img.set_pixel(x, y, BLOOD_COLOR)
	
	# Boca torcida (dolor)
	for x in range(26, 38):
		var offset = sin(x * 0.3) * 2
		img.set_pixel(x, 46 + int(offset), SKIN_SHADOW.darkened(0.3))

func _draw_badly_hurt(img: Image) -> void:
	"""Estado gravemente herido - sangre abundante"""
	# Sangre en toda la cara
	for y in range(15, 50):
		for x in range(15, 50):
			if randf() > 0.7 and img.get_pixel(x, y).a > 0:
				img.set_pixel(x, y, BLOOD_COLOR)
	
	# Ojos inyectados en sangre
	_draw_eye(img, 24, 28, true)
	_draw_eye(img, 40, 28, true)
	
	# Boca abierta (grito de dolor)
	for y in range(44, 52):
		for x in range(28, 36):
			img.set_pixel(x, y, Color(0.1, 0.05, 0.05))

func _draw_critical(img: Image) -> void:
	"""Estado crítico - cara ensangrentada, casi muerto"""
	# Cara muy pálida (casi gris)
	for y in range(10, 54):
		for x in range(12, 52):
			var pixel = img.get_pixel(x, y)
			if pixel.a > 0 and pixel != BLOOD_COLOR:
				var gray = (pixel.r + pixel.g + pixel.b) / 3
				img.set_pixel(x, y, Color(gray, gray, gray) * 0.7)
	
	# Sangre muy abundante
	for y in range(12, 52):
		for x in range(14, 50):
			if randf() > 0.5:
				img.set_pixel(x, y, BLOOD_COLOR.darkened(0.2))
	
	# Ojos desencajados (blancos)
	_draw_eye_white(img, 24, 28)
	_draw_eye_white(img, 40, 28)
	
	# Tinte warp (corrupción lovecraftiana)
	for y in range(10, 54):
		for x in range(12, 52):
			if randf() > 0.9:
				var current = img.get_pixel(x, y)
				if current.a > 0:
					img.set_pixel(x, y, current.lerp(WARP_TINT, 0.3))

func _draw_eye_white(img: Image, cx: int, cy: int) -> void:
	"""Dibuja un ojo en blanco (desencajado)"""
	for y in range(cy - 3, cy + 4):
		for x in range(cx - 4, cx + 5):
			var dx = (x - cx) / 4.0
			var dy = (y - cy) / 3.0
			if dx*dx + dy*dy <= 1.0:
				img.set_pixel(x, y, Color(0.9, 0.9, 0.85))

func update_health(health_percent: float) -> void:
	"""Actualiza el retrato según el porcentaje de salud"""
	current_health_percent = clamp(health_percent, 0, 100)
	
	# Determinar estado
	var new_state: DamageState
	if current_health_percent >= 80:
		new_state = DamageState.HEALTHY
	elif current_health_percent >= 60:
		new_state = DamageState.WORRIED
	elif current_health_percent >= 40:
		new_state = DamageState.HURT
	elif current_health_percent >= 20:
		new_state = DamageState.BADLY_HURT
	else:
		new_state = DamageState.CRITICAL
	
	# Actualizar si cambió el estado
	if new_state != current_state:
		current_state = new_state
		_update_portrait()
		print("Estado de retrato cambiado a: %s (%.0f%%)" % [DamageState.keys()[current_state], current_health_percent])

func _update_portrait() -> void:
	"""Actualiza la textura del retrato"""
	if portrait_rect and portrait_textures.size() > current_state:
		portrait_rect.texture = portrait_textures[current_state]
		
		# Efecto de flash rojo al recibir daño
		if damage_overlay:
			_flash_damage()

func _flash_damage() -> void:
	"""Efecto de flash rojo al recibir daño"""
	if damage_overlay:
		damage_overlay.color = Color(1, 0, 0, 0.3)
		var tween = create_tween()
		tween.tween_property(damage_overlay, "color:a", 0.0, 0.3)

func set_custom_portrait(textures: Array[ImageTexture]) -> void:
	"""Establece texturas personalizadas (para cuando Pixel Pete entregue los sprites)"""
	if textures.size() == 5:
		portrait_textures = textures
		_update_portrait()
		print("Retratos personalizados cargados")
	else:
		push_error("Se esperaban 5 texturas, se recibieron %d" % textures.size())
