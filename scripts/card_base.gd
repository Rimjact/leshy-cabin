class_name CardBase
extends Node2D
## Класс карточки


@export_group("Card Properties")
## Состояние карточки
@export var state: Global.CardState = Global.CardState.IN_DECK

@export_group("Components")
## Компонент ввода карточки
@export var card_input_component: CardInputComponent


## Когда курсор навёлся на эту карточку
func _on_card_hover_started(card: CardBase) -> void:
	if card != self:
		return
	
	_hover()


## Когда курсор ушёл с этой карточки
func _on_card_hover_stopped(card: CardBase) -> void:
	if card != self:
		return
	
	_remove_hover()


## Когда карточка выбрана
func _on_card_selected(card: CardBase) -> void:
	if card != self:
		return
	
	card.state = Global.CardState.IN_HAND_SELECTED


## Когда выбор карточки снят
func _on_card_deselected(card: CardBase) -> void:
	if card != self:
		return
	
	card.state = Global.CardState.IN_HAND_HOVERED


## Когда позиция карточки в руке игрока обновлена 
func _on_card_in_player_deck_position_updated(card: CardBase, index: int, cards_count: int) -> void: 
	if card != self:
		return
	
	var is_selected: bool = state == Global.CardState.IN_HAND_SELECTED
	
	state = Global.CardState.ON_MOVE
	
	var player_deck_node: Node2D = get_parent()
	var new_pos_y: float = player_deck_node.global_position.y
	var new_pos_x: float = _calc_new_pos_x(index, cards_count)
	
	var new_pos := Vector2(new_pos_x, new_pos_y)
	
	if is_selected:
		new_pos.y -= 3.0
		_change_pos_tween(new_pos, Global.CardState.IN_HAND_SELECTED)
		return
	
	_change_pos_tween(new_pos, Global.CardState.IN_HAND)


## Когда игроку добавлена карточка
func _on_player_card_added(card: CardBase) -> void:
	if card != self:
		return
	
	card_input_component.enable_input()
	visible = true
	state = Global.CardState.IN_HAND


## Когда карточка установлена на слот
func _on_slot_card_placed(slot: SlotBase, card: CardBase) -> void:
	if card != self:
		return
	
	state = Global.CardState.ON_MOVE
	
	_change_pos_tween(slot.global_position, Global.CardState.IN_SLOT)


## Когда твин пермещения карточки завершён
func _on_change_pos_tween_completed(target_state: Global.CardState) -> void:
	state = target_state


## Выделяет карточку среди прочих
func _hover() -> void:
	state = Global.CardState.IN_HAND_HOVERED
	
	z_index = 3
	
	var hover_pos: Vector2 = _calc_hover_pos(true)
	_hover_tween(hover_pos)


## Убирает выделение карточки среди прочих
func _remove_hover() -> void:
	state = Global.CardState.IN_HAND
	
	z_index = 2
	
	var remove_hover_pos: Vector2 = _calc_hover_pos(false)
	_hover_tween(remove_hover_pos)


## Расчитывает позицию для выделения карточки или для снятия выделения
func _calc_hover_pos(is_hover: bool) -> Vector2:
	var player_deck_node: Node2D = get_parent() 
	var y_center: float = player_deck_node.global_position.y
	
	var hover_x: float = global_position.x
	var hover_y: float = y_center - 3 if is_hover else y_center
	
	return Vector2(hover_x, hover_y)


## Рассчитывает позицию карточки по координате X, учитывая её индекс
func _calc_new_pos_x(index: int, cards_count: int) -> float:
	var player_deck_node: Node2D = get_parent()
	var x_center: float = player_deck_node.global_position.x
	
	if cards_count == 1:
		return x_center
	
	var total_cards_width: float = cards_count * Global.CARD_WIDTH_PIX
	if total_cards_width > Global.MAX_HAND_DECK_WIDTH_PIX:
		return _calc_new_pos_x_compressed(index, cards_count, x_center)
	
	return _calc_new_pos_x_normal(index, total_cards_width, x_center)


## Рассчитывает сжатую позицию карточки по координате X, учитывая её индекс
func _calc_new_pos_x_compressed(index: int, cards_count: int, x_center: float) -> float:
	var x_pos_step: float = Global.MAX_HAND_DECK_WIDTH_PIX / cards_count
	var x_offset: float = x_center + index * Global.MAX_HAND_DECK_WIDTH_PIX / cards_count
	var x_pos: float = x_offset - Global.MAX_HAND_DECK_WIDTH_PIX / 2.0 + (Global.CARD_WIDTH_PIX - (Global.CARD_WIDTH_PIX - x_pos_step)) / 2.0
	
	return x_pos


## Рассчитывает нормальную позицию карточки по координате X, учитывая её индекс
func _calc_new_pos_x_normal(index: int, total_cards_width: float, x_center: float) -> float:
	var x_offset: float = x_center + index * Global.CARD_WIDTH_PIX
	var x_pos: float = x_offset - total_cards_width / 2.0 + Global.CARD_WIDTH_PIX / 2.0
	
	return x_pos


## Плавно перемещает карточку для выделения
func _hover_tween(target_pos: Vector2) -> void:
	var hover_tween = get_tree().create_tween()
	hover_tween.tween_property(self, "global_position", target_pos, .2)


## Плавно перемещает карточку на новую позицию и задаёт состояние
func _change_pos_tween(target_pos: Vector2, target_state: Global.CardState) -> void:
	var change_pos_tween = get_tree().create_tween()
	change_pos_tween.tween_property(self, "global_position", target_pos, .2)
	change_pos_tween.tween_callback(_on_change_pos_tween_completed.bind(target_state))


## Подключает к сигналам Шины
func _connect_to_signals() -> void:
	EventBus.card_hover_started.connect(_on_card_hover_started)
	EventBus.card_hover_stopped.connect(_on_card_hover_stopped)
	EventBus.card_selected.connect(_on_card_selected)
	EventBus.card_deselected.connect(_on_card_deselected)
	EventBus.card_in_player_deck_position_updated.connect(_on_card_in_player_deck_position_updated)
	EventBus.player_card_added.connect(_on_player_card_added)
	EventBus.slot_card_placed.connect(_on_slot_card_placed)
