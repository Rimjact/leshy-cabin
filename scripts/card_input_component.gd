class_name CardInputComponent
extends Node
## Класс карточки для обработки ввода


## Курсор мыши навёлся на эту карточку
func on_mouse_entered() -> void:
	EventBus.card_cursor_entered.emit(self)


## Курсор мыши навёлся на эту карточку
func on_mouse_exited() -> void:
	EventBus.card_cursor_exited.emit(self)


## Когда произошел левый клик по компоненту
func on_mouse_left_button_clicked(source: ClickboxComponent) -> void:
	if not _is_source_parent_equels_self_parent(source):
		return
	
	EventBus.card_cursor_left_button_clicked.emit(self)


## Когда произошел правый клик по компоненту
func on_mouse_right_button_clicked(source: ClickboxComponent) -> void:
	if not _is_source_parent_equels_self_parent(source):
		return
	
	EventBus.card_cursor_right_button_clicked.emit(self)


## Проверяет, является ли родительская нода источника этой карточкой
func _is_source_parent_equels_self_parent(source: ClickboxComponent) -> bool:
	var source_parent = source.get_parent()
	if source_parent is not CardBase:
		return false
	
	var source_card_node: CardBase = source_parent
	var self_card_node: CardBase = get_parent()
	return source_card_node == self_card_node
