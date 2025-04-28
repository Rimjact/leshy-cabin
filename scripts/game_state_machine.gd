class_name GameStateMachine
extends Node2D
## Класс контроллера игры.


## Исходное состояние игры.
@export var initial_state: GameState

## Список состояний игры.
var states: Dictionary = {}
## Текущее состояние игры.
var cur_state: GameState


func _ready() -> void:
    _get_game_states()
    _init_state()


## Обработчик события, когда состояние игры изменено.
func on_game_state_changed(new_state: GameState) -> void:
    if new_state != cur_state:
        return

    var target_state = states.get(new_state.name.to_lower())
    if not target_state:
        return

    if cur_state:
        cur_state.exit()

    target_state.enter()


## Получает состояния игры в дочерних нодах.
func _get_game_states() -> void:
    for child: Node in get_children():
        if child is GameState:
            var state_name: String = child.name.to_lower()
            states[state_name] = child


## Инициализирует текущее состояние.
func _init_state() -> void:
    if initial_state:
        initial_state.enter()
        cur_state = initial_state


## Подключает методы к событиям.
func _connect_to_event() -> void:
    EventBus.game_state_changed.connect(on_game_state_changed)