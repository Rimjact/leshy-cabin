class_name GameStatePlayerTurn
extends GameState
## Класс состояния игры, отвечающий за ход игрока.


func _enter() -> void:
	print("player_turn: enter")


func _exit() -> void:
	print("player_turn: exit")


## Когда курсор кликнул левой кнопкой мыши по звоночку.
func on_bell_cursor_left_button_clicked() -> void:
	if not _is_current_state():
		return

	EventBus.game_state_changed.emit(self, "player_cards_attack")


func _subscribe_on_events() -> void:
	EventBus.bell_cursor_left_button_clicked.connect(on_bell_cursor_left_button_clicked)