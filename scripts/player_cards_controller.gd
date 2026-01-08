class_name PlayerCardsController
extends Node2D
## Класс для управленя карточками игрока


## Карточки у игрока
var cards: Array[CardBase] 

## Наведён ли в данный момент курсор на карточку
var _is_card_hovered: bool = false


## Когда на карточку навёлся курсор
func _on_card_cursor_entered(card: CardBase) -> void:
	if _is_card_hovered:
		return
	if card.state != Global.CardState.IN_HAND:
		return
	
	EventBus.card_hover_started.emit(card)
	_is_card_hovered = true


## Когда курсор ушёл с карточки
func _on_card_cursor_exited(card: CardBase) -> void:
	if not _is_card_hovered:
		return
	if card.state != Global.CardState.IN_HAND_HOVERED:
		return
	
	EventBus.card_hover_stopped.emit(card)
	_is_card_hovered = false


## Присоединяет к сигналам Шины
func _connect_to_signals() -> void:
	EventBus.card_cursor_entered.connect(_on_card_cursor_entered)
	EventBus.card_cursor_exited.connect(_on_card_cursor_exited)
