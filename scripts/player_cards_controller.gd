class_name PlayerCardsController
extends Node2D
## Класс для управленя карточками игрока


@export var hand_state: Global.HandState = Global.HandState.IDLE
## Карточки у игрока
@export var cards: Array[CardBase]

var _card_selected: CardBase = null


## Когда на карточку навёлся курсор
func _on_card_cursor_entered(card: CardBase) -> void:
	if _is_can_hovered(card):
		_start_hover_card(card)


## Когда курсор ушёл с карточки
func _on_card_cursor_exited(card: CardBase) -> void:
	if _is_can_unhovered(card):
		_stop_hover_card(card)


## Когда произошел левый клик по карточке
func _on_card_cursor_left_button_clicked(card: CardBase) -> void:
	if _is_can_sacrifaced(card):
		_sacriface_card(card)
		return
	
	if _is_can_selected(card):
		_select_card(card)
		return
	
	if _is_can_deselected(card):
		_deselect_card(card)
		return


## Когда произошел левый клик по слоту
func _on_slot_cursor_left_button_clicked(slot: SlotBase) -> void:
	if _is_card_can_be_placed(slot, _card_selected):
		_place_card_to_slot(slot, _card_selected)
		return


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


##
func _on_barter_sacriface_mode_entered(_card: CardBase) -> void:
	hand_state = Global.HandState.SACRIFACE


##
func _on_barter_sacriface_mode_exited() -> void:
	hand_state = Global.HandState.IDLE


##
func _on_barter_card_sacrifaced(_card: CardBase) -> void:
	if hand_state == Global.HandState.SACRIFACE_LOCK:
		return
	
	hand_state = Global.HandState.SACRIFACE_LOCK


##
func _on_barter_card_completed(_card: CardBase) -> void:
	hand_state = Global.HandState.PICKED_UP_CARD


## Возвращает true если карточка может быть выделена
func _is_can_hovered(card: CardBase) -> bool:
	if hand_state != Global.HandState.IDLE:
		return false
	if card.state != Global.CardState.IN_HAND:
		return false
	
	return true


## Возвращает true если можно снять выделение с карточки
func _is_can_unhovered(card: CardBase) -> bool:
	if card.state != Global.CardState.IN_HAND_HOVERED:
		return false
	
	return true


## Запускает выделения карточки, если она в руке
func _start_hover_card(card: CardBase) -> void:  
	EventBus.card_hover_started.emit(card)


## Останавливает выделение карточки, если она была выделена
func _stop_hover_card(card: CardBase) -> void:
	EventBus.card_hover_stopped.emit(card)


## Вернёт true если карточка может быть выбрана
func _is_can_selected(card: CardBase) -> bool:
	if _card_selected:
		return false
	if hand_state != Global.HandState.IDLE:
		return false
	if card.state != Global.CardState.IN_HAND_HOVERED:
		return false
	
	return true


## Вернёт true если можно снять выделение с карточки
func _is_can_deselected(card: CardBase) -> bool:
	if not _card_selected:
		return false
	if hand_state != Global.HandState.IDLE:
		return false
	if _card_selected != card:
		return false
	if card.state != Global.CardState.IN_HAND_SELECTED:
		return false
	
	return true


## Выбирает карточку
func _select_card(card: CardBase) -> void:
	_card_selected = card
	EventBus.card_selected.emit(card)


## Снимает выдиление с карточки
func _deselect_card(card: CardBase) -> void:
	_card_selected = null
	EventBus.card_deselected.emit(card)


## Вернёт true если карточку можно разместить на слоте
func _is_card_can_be_placed(slot: SlotBase, card: CardBase) -> bool:
	if not card:
		return false
	if hand_state != Global.HandState.PICKED_UP_CARD:
		return false
	if slot.side != Global.BattleSide.PLAYER:
		return false
	if slot.card:
		return false
	
	return true


## Помещает карточку на слот
func _place_card_to_slot(slot: SlotBase, card: CardBase) -> void:
	EventBus.slot_card_placed.emit(slot, card)
	
	cards.erase(card)
	_card_selected = null
	
	EventBus.player_cards_count_changed.emit()


##
func _is_can_sacrifaced(card: CardBase) -> bool:
	if not hand_state in [Global.HandState.SACRIFACE, Global.HandState.SACRIFACE_LOCK]:
		return false
	if not _card_selected:
		return false
	if card.state != Global.CardState.IN_SLOT:
		return false
	
	return true


##
func _sacriface_card(card: CardBase) -> void:
	EventBus.barter_card_sacrifaced.emit(card)


## Присоединяет к сигналам Шины
func _connect_to_signals() -> void:
	EventBus.card_cursor_entered.connect(_on_card_cursor_entered)
	EventBus.card_cursor_exited.connect(_on_card_cursor_exited)
	EventBus.card_cursor_left_button_clicked.connect(_on_card_cursor_left_button_clicked)
	EventBus.slot_cursor_left_button_clicked.connect(_on_slot_cursor_left_button_clicked)
	EventBus.player_cards_count_changed.connect(_on_player_cards_count_changed)
	EventBus.player_card_added.connect(_on_player_card_added)
	EventBus.barter_card_sacrifaced.connect(_on_barter_card_sacrifaced)
	EventBus.barter_card_completed.connect(_on_barter_card_completed)


## Включает правильную сортировку для выбора объектов
func _enable_picking_sort() -> void:
	var view_port: Viewport = get_viewport()
	view_port.physics_object_picking_sort = true
	view_port.physics_object_picking_first_only = true
