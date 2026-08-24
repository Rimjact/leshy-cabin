class_name BellBase
extends Node2D
## Класс звоночка


## Текущее состояние звоночка
var state: Global.BellState = Global.BellState.PRESSED


## Когда произошел левый клик по звоночку
func _on_bell_cursor_left_button_clicked(bell: BellBase) -> void:
	if bell != self:
		return
	if state != Global.BellState.RELEASED:
		return
	
	EventBus.bell_move_passed.emit()


## Когда состояние игры изменено
func _on_game_state_changed(new_state: Global.GameState) -> void:
	match new_state:
		Global.GameState.PLAYER_TURN:
			_chagne_bell_state(Global.BellState.RELEASED)
		Global.GameState.PLAYER_CARDS_ATTACK:
			_chagne_bell_state(Global.BellState.PRESSED)


##
func _on_barter_sacriface_mode_entered(_card: CardBase) -> void:
	_chagne_bell_state(Global.BellState.PRESSED)


##
func _on_barter_sacriface_mode_exited() -> void:
	_chagne_bell_state(Global.BellState.RELEASED)


##
func _on_barter_card_prepare(_card: CardBase) -> void:
	_chagne_bell_state(Global.BellState.PRESSED)


##
func _on_card_deselected(_card: CardBase) -> void:
	_chagne_bell_state(Global.BellState.RELEASED)


##
func _on_barter_card_completed(_card: CardBase) -> void:
	_chagne_bell_state(Global.BellState.RELEASED)


## Изменяет текущее состояние звоночка
func _chagne_bell_state(new_state: Global.BellState) -> void:
	state = new_state
	
	EventBus.bell_state_changed.emit(new_state)


## Присоединяет сигналы Шины
func _connect_signals() -> void:
	EventBus.bell_cursor_left_button_clicked.connect(_on_bell_cursor_left_button_clicked)
	EventBus.game_state_changed.connect(_on_game_state_changed)
	EventBus.barter_sacriface_mode_entered.connect(_on_barter_sacriface_mode_entered)
	EventBus.barter_sacriface_mode_exited.connect(_on_barter_sacriface_mode_exited)
	EventBus.barter_card_bones_prepare.connect(_on_barter_card_prepare)
	EventBus.barter_card_free_prepare.connect(_on_barter_card_prepare)
	EventBus.barter_card_completed.connect(_on_barter_card_completed)
	EventBus.card_deselected.connect(_on_card_deselected)
