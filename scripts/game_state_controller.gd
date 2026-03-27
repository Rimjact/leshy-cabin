class_name GameStateController
extends Node2D
## Класс контроллера состояния игры


## Текущее состояние игры
@export var state: Global.GameState = Global.GameState.GAME_INIT

var _logger: GameLogger


func _ready() -> void:
	_logger = Logging.create_logger("GameStateController")
	_logger.add_handler(Logging.create_console_handler())
	_logger.add_handler(Logging.create_file_handler())
	
	_logger.info("Готов")


## Преключает состояние игры на следующее
func _to_next_game_state() -> void:
	if state in [Global.GameState.GAME_INIT, Global.GameState.OPPONENT_PICK_CARD]:
		_change_game_state(Global.GameState.PLAYER_PICK_CARD)
		return
	
	var new_state: Global.GameState = state + 1 as Global.GameState
	_change_game_state(new_state)


## Переключает состояние игры
func _change_game_state(new_state: Global.GameState) -> void:
	state = new_state
	
	_logger.info("== Состояние игры изменено на {0} ==".format([new_state]))
	
	EventBus.game_state_changed.emit(new_state)


## Подключает сигналы Шины
func _connect_signals() -> void:
	EventBus.deck_card_given.connect(_to_next_game_state)
	EventBus.bell_move_passed.connect(_to_next_game_state)
	EventBus.battle_player_cards_attack_ended.connect(_to_next_game_state)
	EventBus.battle_opponent_cards_attack_ended.connect(_to_next_game_state)
