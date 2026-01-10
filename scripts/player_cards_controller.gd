class_name PlayerCardsController
extends Node2D
## Класс для управленя карточками игрока


## Карточки у игрока
@export var cards: Array[CardBase]

var _card_selected: CardBase = null


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


## Когда произошел левый клик по карточке
func _on_card_cursor_left_button_clicked(card: CardBase) -> void:
	if not _card_selected and card.state == Global.CardState.IN_HAND_HOVERED:
		_card_selected = card
		EventBus.card_selected.emit(card)
		return
	
	if card.state != Global.CardState.IN_HAND_SELECTED:
		return
	
	if _card_selected and _card_selected != card:
		return
	
	_card_selected = null
	EventBus.card_deselected.emit(card)


## Когда количество карт в руке игрока обновлено
func _on_player_cards_count_changed() -> void:
	var cards_count: int = cards.size()
	var index: int = 0
	for card: CardBase in cards:
		EventBus.card_in_player_deck_position_updated.emit(card, index, cards_count)
		index += 1


## Когда карточка была добавлена игроку
func _on_player_card_added(card: CardBase) -> void:
	card.reparent(self)
	cards.push_back(card)
	
	EventBus.player_cards_count_changed.emit()


## Присоединяет к сигналам Шины
func _connect_to_signals() -> void:
	EventBus.card_cursor_entered.connect(_on_card_cursor_entered)
	EventBus.card_cursor_exited.connect(_on_card_cursor_exited)
	EventBus.card_cursor_left_button_clicked.connect(_on_card_cursor_left_button_clicked)
	EventBus.player_cards_count_changed.connect(_on_player_cards_count_changed)
	EventBus.player_card_added.connect(_on_player_card_added)


## Включает правильную сортировку для выбора объектов
func _enable_picking_sort() -> void:
	var view_port: Viewport = get_viewport()
	view_port.physics_object_picking_sort = true
	view_port.physics_object_picking_first_only = true
