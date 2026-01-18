class_name GameStateController
extends Node2D
## Класс контроллера состояния игры


## Исходное состояние игры
@export var initial_state: Global.GameState = Global.GameState.GAME_INIT

## Текущее состояние игры
var state: Global.GameState


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
	EventBus.game_state_changed.emit(new_state)
	print("GameStateController: game state changed")


## Подключает сигналы Шины
func _connect_signals() -> void:
	EventBus.deck_card_given.connect(_to_next_game_state)
	EventBus.bell_move_passed.connect(_to_next_game_state)
	EventBus.battle_player_cards_attack_ended.connect(_to_next_game_state)
	EventBus.battle_opponent_cards_attack_ended.connect(_to_next_game_state)
