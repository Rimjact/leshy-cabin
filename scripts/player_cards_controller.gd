class_name PlayerCardsController
extends Node2D
## Класс контроллера карточек игрока.


## (Константа) Ширина игровой карточки + правый отступ.
const CARD_WIDTH: float = 49 + 2
## (Константа) Максимальная ширина колоды в руке.
const MAX_HAND_DECK_WIDTH: float = 224

## Нода менеджера ввода.
@export var input_manager: InputManager
## Массив карточек, находящихся у игрока.
@export var cards: Array[Card]

## Карточка, на которую наведён курсор.
var _hovered_card: Card = null
## Карточка, которая выбрана на данный момент.
var _selected_card: Card = null


func _ready() -> void:
	_subscribe_on_events()
	update_cards_positions()


## Когда на карточку навёлся курсор.
func on_card_cursor_entered(card: Card) -> void:
	if _hovered_card != null:
		return
	if card.state != Global.CardState.IN_HAND:
		return
	if _selected_card:
		return

	highlight_card(card, true)
	_hovered_card = card


## Когда от карточки ушёл курсор.
func on_card_cursor_exited(card: Card) -> void:
	if card.state != Global.CardState.IN_HAND:
		return
	if _selected_card:
		return

	highlight_card(card, false)

	var another_card: Card = input_manager.get_card_node_on_mouse_pos()
	if another_card != null:
		highlight_card(another_card, true)
		_hovered_card = another_card
		return

	_hovered_card = null


## Когда курсор кликнул на карточку левой кнопкой мыши.
func on_card_cursor_left_button_clicked(card: Card) -> void:
	if card.state != Global.CardState.IN_HAND:
		return
	if not _selected_card:
		select_card(card)
		return
	if _selected_card and card != _selected_card:
		return

	deselect_card()


## Когда курсор кликнул на карточку правой кнопкой мыши.
func on_card_cursor_right_button_clicked(card: Card) -> void:
	print(card)


## Подсвечивает указанную карточку.
func highlight_card(card: Card, is_hovered: bool) -> void:
	card.z_index = 3 if is_hovered else 2

	var y_center = self.global_position.y

	var target_x: float = card.global_position.x
	var target_y: float = y_center - 3 if is_hovered else y_center
	var target_pos: Vector2 = Vector2(target_x, target_y)

	var tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", target_pos, .2)


## Добавляет выделение карточку.
func select_card(card: Card) -> void:
	_selected_card = card
	highlight_card(_selected_card, true)


## Снимает выделение с карточки.
func deselect_card() -> void:
	highlight_card(_selected_card, false)
	_selected_card = null


## Обновляет позицию карточек, находящихся у игрока.
##
## NOTE: Используется только для обновления позиций карт у игрока "в руке".
func update_cards_positions() -> void:
	var index: int = 0
	for card: Card in cards:
		var target_pos: Vector2 = get_card_pos(index)
		animate_card_move_in_hand(card, target_pos)
		index += 1


## Возвращает позицию карточки по её индексу.
func get_card_pos(index: int) -> Vector2:
	return Vector2(get_card_pos_x(index), self.global_position.y)


## Возвращает позицию карточки по координате X, учитыая её индекс.
func get_card_pos_x(index: int) -> float:
	var cards_count: float = cards.size()
	var x_center: float = self.global_position.x

	if cards_count == 1:
		return x_center

	var total_cards_width: float = cards_count * CARD_WIDTH
	if total_cards_width > MAX_HAND_DECK_WIDTH:
		return calc_compressed_card_pos_x(index, cards_count, x_center)

	return calc_normal_card_pos_x(index, total_cards_width, x_center)


## Рассчитывает нормальную позицию карточки по координате X, учитывая её индекс в массиве.
func calc_normal_card_pos_x(index: int, total_cards_width: float, x_center: float) -> float:
	var x_offset: float = x_center + index * CARD_WIDTH
	var x_pos: float = x_offset - total_cards_width / 2.0 + CARD_WIDTH / 2.0

	return x_pos


## Рассчитывает сжатую позицию карточки по координате X, учитывая её индекс в массиве.
func calc_compressed_card_pos_x(index: int, cards_count: float, x_center: float) -> float:
	var x_pos_step: float = MAX_HAND_DECK_WIDTH / cards_count
	var x_offset: float = x_center + index * MAX_HAND_DECK_WIDTH / cards_count
	var x_pos: float = x_offset - MAX_HAND_DECK_WIDTH / 2.0 + (CARD_WIDTH - (CARD_WIDTH - x_pos_step)) / 2.0

	return x_pos


## Выполняет плавную анимацию движения карточки до указанной точки.
func animate_card_move_in_hand(card: Card, target_pos: Vector2) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", target_pos, .2)
	tween.tween_callback(update_card_state.bind(card, Global.CardState.IN_HAND))


## Обновляет состояние карточки.
func update_card_state(card: Card, state: Global.CardState) -> void:
	card.state = state


## Подписывает на нужные события EventBus.
func _subscribe_on_events() -> void:
	EventBus.card_cursor_entered.connect(on_card_cursor_entered)
	EventBus.card_cursor_exited.connect(on_card_cursor_exited)
	EventBus.card_cursor_left_button_clicked.connect(on_card_cursor_left_button_clicked)
	EventBus.card_cursor_right_button_clicked.connect(on_card_cursor_right_button_clicked)
