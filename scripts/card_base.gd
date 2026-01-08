class_name CardBase
extends Node2D
## Класс карточки


@export_group("Components")
@export var clickbox_component: ClickboxComponent

## Состояние карточки
@export var state: Global.CardState = Global.CardState.IN_DECK


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


## Выделяет карточку среди прочих
func _hover() -> void:
	state = Global.CardState.IN_HAND_HOVERED
	
	z_index = 3
	
	var hover_pos: Vector2 = _calc_hover_pos(true)
	_move_to_smoothly(hover_pos)


## Убирает выделение карточки среди прочих
func _remove_hover() -> void:
	state = Global.CardState.IN_HAND
	
	z_index = 2
	
	var remove_hover_pos: Vector2 = _calc_hover_pos(false)
	_move_to_smoothly(remove_hover_pos)


## Расчитывает позицию для выделения карточки или для снятия выделения
func _calc_hover_pos(is_hover: bool) -> Vector2:
	var player_deck_node: Node2D = get_parent() 
	var y_center: float = player_deck_node.global_position.y
	
	var hover_x: float = global_position.x
	var hover_y: float = y_center - 3 if is_hover else y_center
	
	return Vector2(hover_x, hover_y)


## Плавно перемещает карточку на новую позицию 
func _move_to_smoothly(target_pos: Vector2) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_pos, .2)


## Подключает к сигналам Шины
func _connect_to_signals() -> void:
	EventBus.card_hover_started.connect(_on_card_hover_started)
	EventBus.card_hover_stopped.connect(_on_card_hover_stopped)
