class_name GameStateMachine
extends Node2D
## Класс контроллера игры.


## Исходное состояние игры.
@export var initial_state: GameState

## Список состояний игры.
var states: Dictionary = {}
## Текущее состояние игры.
@export var cur_state: GameState


func _ready() -> void:
    _get_game_states()
    _init_state()
    _subscribe_on_events()


## Обработчик события, когда состояние игры изменено.
func on_game_state_changed(from_state: GameState, to_state_name: String) -> void:
    if from_state != cur_state:
        return

    var target_state: GameState = states.get(to_state_name.to_lower())
    if not target_state:
        return

    if cur_state:
        cur_state._exit()

    target_state._enter()

    cur_state = target_state


## Получает состояния игры в дочерних нодах.
func _get_game_states() -> void:
    for child: Node in get_children():
        if child is GameState:
            var state_name: String = child.name.to_lower()
            states[state_name] = child


## Инициализирует текущее состояние.
func _init_state() -> void:
    if initial_state:
        initial_state._enter()
        cur_state = initial_state


## Подписывает методы на события.
func _subscribe_on_events() -> void:
    EventBus.game_state_changed.connect(on_game_state_changed)