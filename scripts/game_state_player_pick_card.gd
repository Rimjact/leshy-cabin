class_name GameStatePlayerPick
extends GameState
## Класс состояния игры, отвечающий за возможность игроку взять карточку с одной из колод.


func _enter() -> void:
	print("player_pick_card: enter")


func _exit() -> void:
	print("player_pick_card: exit")


## Обработчик события, когда карточка взята с колоды.
func on_deck_card_given(_deck: PlayerDeck, _card: Card) -> void:
	if not _is_current_state():
		return

	EventBus.game_state_changed.emit(self, "player_turn")


func _subscribe_on_events() -> void:
	EventBus.deck_card_given.connect(on_deck_card_given)
