extends Node

## SaveManager - Singleton para guardado/carga
## Maneja: meta-progresión, configuración, estadísticas persistentes

const SAVE_PATH: String = "user://whispering_corridors.save"

# Datos por defecto
var default_data: Dictionary = {
	"version": "0.1.0",
	"total_souls": 0,
	"unlocked_weapons": ["pistola"],
	"unlocked_powerups": [],
	"settings": {
		"master_volume": 1.0,
		"music_volume": 0.7,
		"sfx_volume": 0.8,
		"mouse_sensitivity": 0.002,
		"mouse_invert_y": false
	},
	"stats": {
		"total_runs": 0,
		"total_kills": 0,
		"total_deaths": 0,
		"best_time": 0.0,
		"bosses_defeated": 0
	}
}

var save_data: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_game()
	print("SaveManager inicializado")

func save_game() -> void:
	"""Guarda los datos actuales"""
	# Actualizar datos desde GameManager
	save_data["total_souls"] = GameManager.total_souls
	save_data["unlocked_weapons"] = GameManager.unlocked_weapons
	save_data["unlocked_powerups"] = GameManager.unlocked_powerups
	
	# Guardar configuración desde managers
	save_data["settings"]["master_volume"] = AudioManager.master_volume
	save_data["settings"]["music_volume"] = AudioManager.music_volume
	save_data["settings"]["sfx_volume"] = AudioManager.sfx_volume
	save_data["settings"]["mouse_sensitivity"] = InputManager.mouse_sensitivity
	save_data["settings"]["mouse_invert_y"] = InputManager.mouse_invert_y
	
	# Escribir archivo
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()
		print("Partida guardada")
	else:
		push_error("Error al guardar partida")

func load_game() -> void:
	"""Carga los datos guardados"""
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			save_data = file.get_var()
			file.close()
			
			# Aplicar datos cargados
			_apply_loaded_data()
			print("Partida cargada")
		else:
			push_error("Error al cargar partida")
			_reset_to_defaults()
	else:
		print("No hay partida guardada, usando valores por defecto")
		_reset_to_defaults()

func _apply_loaded_data() -> void:
	"""Aplica los datos cargados a los managers"""
	# Meta-progresión
	GameManager.total_souls = save_data.get("total_souls", 0)
	GameManager.unlocked_weapons = save_data.get("unlocked_weapons", ["pistola"])
	GameManager.unlocked_powerups = save_data.get("unlocked_powerups", [])
	
	# Configuración
	var settings = save_data.get("settings", {})
	AudioManager.master_volume = settings.get("master_volume", 1.0)
	AudioManager.music_volume = settings.get("music_volume", 0.7)
	AudioManager.sfx_volume = settings.get("sfx_volume", 0.8)
	InputManager.mouse_sensitivity = settings.get("mouse_sensitivity", 0.002)
	InputManager.mouse_invert_y = settings.get("mouse_invert_y", false)

func _reset_to_defaults() -> void:
	"""Restablece valores por defecto"""
	save_data = default_data.duplicate(true)
	_apply_loaded_data()

func reset_save() -> void:
	"""Borra todos los datos guardados"""
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	_reset_to_defaults()
	print("Partida borrada")

func get_stat(stat_name: String) -> Variant:
	"""Obtiene una estadística"""
	return save_data.get("stats", {}).get(stat_name, 0)

func set_stat(stat_name: String, value: Variant) -> void:
	"""Establece una estadística"""
	if not save_data.has("stats"):
		save_data["stats"] = {}
	save_data["stats"][stat_name] = value

func increment_stat(stat_name: String, amount: int = 1) -> void:
	"""Incrementa una estadística"""
	var current = get_stat(stat_name)
	set_stat(stat_name, current + amount)
