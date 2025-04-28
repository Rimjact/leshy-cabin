class_name GameState
extends Node2D
## Класс состояния игры.


## Автомат состояний игры.
@onready var game_state_machine: GameStateMachine = get_parent()


func _ready() -> void:
    _subscribe_on_events()


## Перезаписываемый метод входа в состояние.
func _enter() -> void:
    pass


## Перезаписываемый метод выхода из состояния.
func _exit() -> void:
    pass


## Проверяет, является ли это состояние игры текущим.
func _is_current_state() -> bool:
    return game_state_machine.cur_state == self


## Подписывает методы на события.
func _subscribe_on_events() -> void:
    pass