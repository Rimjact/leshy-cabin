class_name PlayerCardSlot
extends Node2D
## Класс слота для карточки игрока.


## Карточка, которая в данный момент помещена на слот.
var card: Card = null


## Когда на мышке нажата левая конопка мыши по компоненту.
func on_mouse_left_button_clicked(source: ClickboxComponent) -> void:
	var source_parent = source.get_parent()
	if source_parent is not PlayerCardSlot:
		return

	var card_node: PlayerCardSlot = source_parent
	if card_node != self:
		return

	EventBus.card_slot_cursor_left_button_clicked.emit(self)


## Когда на мышке нажата правая конопка мыши по компоненту.
func on_mouse_right_button_clicked(source: ClickboxComponent) -> void:
	var source_parent = source.get_parent()
	if source_parent is not PlayerCardSlot:
		return

	var card_node: PlayerCardSlot = source_parent
	if card_node != self:
		return

	EventBus.card_slot_cursor_right_button_clicked.emit(self)
