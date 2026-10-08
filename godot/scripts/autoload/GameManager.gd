extends Node

## GameManager - Singleton para gestión global del estado del juego
## Maneja: estado del juego, pausa, transiciones, estadísticas globales

signal game_paused
signal game_resumed
signal player_died
signal level_completed
signal boss_defeated

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	DEAD,
	LEVEL_COMPLETE
}

var current_state: GameState = GameState.MENU
var current_level: String = ""
var run_time: float = 0.0
var enemies_killed: int = 0
var souls_collected: int = 0

# Estadísticas del jugador (persisten entre niveles)
var player_max_health: int = 100
var player_health: int = 100
var player_armor: int = 0
var player_souls: int = 0

# Meta-progresión (persiste entre runs)
var total_souls: int = 0
var unlocked_weapons: Array = ["pistola"]
var unlocked_powerups: Array = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("GameManager inicializado")

func _process(delta: float) -> void:
	if current_state == GameState.PLAYING:
		run_time += delta

func start_new_run() -> void:
	current_state = GameState.PLAYING
	run_time = 0.0
	enemies_killed = 0
	souls_collected = 0
	player_health = player_max_health
	player_armor = 0
	print("Nueva run iniciada")

func pause_game() -> void:
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true
		game_paused.emit()

func resume_game() -> void:
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false
		game_resumed.emit()

func player_die() -> void:
	current_state = GameState.DEAD
	player_died.emit()
	# Guardar almas en meta-progresión
	total_souls += souls_collected
	SaveManager.save_game()

func complete_level() -> void:
	current_state = GameState.LEVEL_COMPLETE
	level_completed.emit()

func add_souls(amount: int) -> void:
	souls_collected += amount
	player_souls += amount

func add_kill() -> void:
	enemies_killed += 1

func get_run_stats() -> Dictionary:
	return {
		"time": run_time,
		"kills": enemies_killed,
		"souls": souls_collected,
		"level": current_level
	}
