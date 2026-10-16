class_name OpponentCardsController
extends Node2D
## Рука противника: хранит карты и раскладывает их у верхнего края


## Карточки в руке противника
@export var cards: Array[CardBase] = []


## Когда противнику добавлена карточка
func _on_opponent_card_added(card: CardBase) -> void:
	card.reparent(self)
	cards.append(card)
	EventBus.opponent_cards_count_changed.emit()


## Когда количество карт в руке противника обновлено
func _on_opponent_cards_count_changed() -> void:
	var cards_count: int = cards.size()
	var index: int = 0
	for card: CardBase in cards:
		EventBus.card_in_player_deck_position_updated.emit(card, index, cards_count)
		index += 1


## Когда карточка установлена на слот
func _on_slot_card_placed(_slot: SlotBase, card: CardBase, _by_card_ability: bool) -> void:
	if not cards.has(card):
		return
	
	cards.erase(card)
	EventBus.opponent_cards_count_changed.emit()


## Присоединяет к сигналам Шины
func _connect_signals() -> void:
	EventBus.opponent_card_added.connect(_on_opponent_card_added)
	EventBus.opponent_cards_count_changed.connect(_on_opponent_cards_count_changed)
	EventBus.slot_card_placed.connect(_on_slot_card_placed)
