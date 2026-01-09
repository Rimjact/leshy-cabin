class_name DeckCounterComponent
extends Label
## Класс компонента счётчика колоды


## Когда игроку добавлена карточка
func _deck_cards_count_updated(deck: DeckBase) -> void:
	var parent_deck: DeckBase = get_parent()
	if deck != parent_deck:
		return
	
	var cards_count: int = parent_deck.cards.size()
	_update_label(cards_count)


## Обновляет текст
func _update_label(cards_count: int) -> void:
	text = var_to_str(cards_count)


## Присоединяет сигналы Шины
func _connect_signals() -> void:
	EventBus.deck_cards_count_updated.connect(_deck_cards_count_updated)
