class_name GameStateController
extends Node2D
## Класс контроллера состояния игры


## Исходное состояние игры
@export var initial_state: Global.GameState

## Текущее состояние игры
var state: Global.GameState


## Преключает состояние игры на следующее
func _to_next_game_state() -> void:
	pass


## Переключает состояние игры
func _change_game_state(new_state: Global.GameState) -> void:
	pass


## Подключает сигналы Шины
func _connect_signals() -> void:
	pass
