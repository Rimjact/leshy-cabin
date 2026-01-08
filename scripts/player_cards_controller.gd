class_name PlayerCardsController
extends Node2D
## Класс для управленя карточками игрока


## Карточки у игрока
var cards: Array[CardBase] 

## Когда на карточку навёлся курсор
func _on_card_cursor_entered(card: CardBase) -> void:
	if card.state != Global.CardState.IN_HAND:
		return
	
	EventBus.card_hover_started.emit(card)


## Когда курсор ушёл с карточки
func _on_card_cursor_exited(card: CardBase) -> void:
	if card.state != Global.CardState.IN_HAND_HOVERED:
		return
	
	EventBus.card_hover_stopped.emit(card)


## Присоединяет к сигналам Шины
func _connect_to_signals() -> void:
	EventBus.card_cursor_entered.connect(_on_card_cursor_entered)
	EventBus.card_cursor_exited.connect(_on_card_cursor_exited)


## Включает правильную сортировку для выбора объектов
func _enable_picking_sort() -> void:
	var view_port: Viewport = get_viewport()
	view_port.physics_object_picking_sort = true
	view_port.physics_object_picking_first_only = true
