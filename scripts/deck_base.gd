class_name DeckBase
extends Node2D
## Класс колоды


@export_group("Deck Properties")
## Тип колоды
@export var type: Global.DeckType = Global.DeckType.ANIMALS

@export_group("Cards")
## Карточки в колоде
@export var cards: Array[CardBase]


## Когда произошел левый клик по колоде
func _on_deck_cursor_left_button_clicked(deck: DeckBase) -> void:
	if deck != self:
		return
	
	_give_card()


## Начинает заполнение этой колоды
func _start_fill() -> void:
	EventBus.deck_fill_started.emit(self)


## Выдаёт карточку из колоды
func _give_card() -> void:
	var card: CardBase = cards.pop_back()
	EventBus.player_card_added.emit(card)
	
	if cards.size() == 0:
		queue_free()


## Подключает к сигналам Шины
func _connect_signals() -> void:
	EventBus.deck_cursor_left_button_clicked.connect(_on_deck_cursor_left_button_clicked)
