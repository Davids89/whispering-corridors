extends Node

## AudioManager - Singleton para gestión de audio
## Maneja: música, SFX, volúmenes, pools de audio

signal music_changed(track_name: String)

# Configuración de volúmenes (0.0 a 1.0)
var master_volume: float = 1.0
var music_volume: float = 0.7
var sfx_volume: float = 0.8

# Buses de audio
var master_bus: int
var music_bus: int
var sfx_bus: int

# Música actual
var current_music: AudioStreamPlayer = null
var current_track: String = ""

# Pool de reproductores SFX
var sfx_players: Array[AudioStreamPlayer] = []
const SFX_POOL_SIZE: int = 8

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Obtener buses de audio
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	
	# Crear pool de SFX
	for i in SFX_POOL_SIZE:
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		sfx_players.append(player)
	
	print("AudioManager inicializado")

func play_music(stream: AudioStream, track_name: String = "") -> void:
	"""Reproduce música de fondo"""
	if current_music:
		current_music.stop()
		current_music.queue_free()
	
	current_music = AudioStreamPlayer.new()
	current_music.stream = stream
	current_music.bus = "Music"
	current_music.autoplay = true
	add_child(current_music)
	current_track = track_name
	music_changed.emit(track_name)

func stop_music() -> void:
	"""Detiene la música actual"""
	if current_music:
		current_music.stop()
		current_music.queue_free()
		current_music = null
		current_track = ""

func play_sfx(stream: AudioStream, position: Vector2 = Vector2.ZERO) -> void:
	"""Reproduce un efecto de sonido"""
	var player = _get_available_sfx_player()
	if player:
		player.stream = stream
		player.global_position = position
		player.play()

func play_sfx_2d(stream: AudioStream, position: Vector2) -> void:
	"""Reproduce un efecto de sonido 2D posicional"""
	var player = AudioStreamPlayer2D.new()
	player.stream = stream
	player.bus = "SFX"
	player.global_position = position
	player.autoplay = true
	get_tree().current_scene.add_child(player)
	
	# Auto-destruir cuando termine
	player.finished.connect(player.queue_free)

func _get_available_sfx_player() -> AudioStreamPlayer:
	"""Obtiene un reproductor SFX disponible del pool"""
	for player in sfx_players:
		if not player.playing:
			return player
	return sfx_players[0]  # Reusar el primero si todos están ocupados

func set_master_volume(value: float) -> void:
	master_volume = clamp(value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(master_volume))

func set_music_volume(value: float) -> void:
	music_volume = clamp(value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_volume))

func set_sfx_volume(value: float) -> void:
	sfx_volume = clamp(value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_volume))

func linear_to_db(linear: float) -> float:
	"""Convierte volumen lineal a decibelios"""
	if linear <= 0:
		return -80
	return 20 * log(linear) / log(10)
