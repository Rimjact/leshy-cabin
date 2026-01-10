class_name SlotInputComponent
extends Node2D
## Класс компонтента ввода слота


## Курсор мыши навёлся на эту карточку
func _on_mouse_entered() -> void:
	EventBus.slot_cursor_entered.emit(get_parent())


## Курсор мыши навёлся на эту карточку
func _on_mouse_exited() -> void:
	EventBus.slot_cursor_exited.emit(get_parent())


## Когда произошел левый клик по компоненту
func _on_mouse_left_button_clicked(source: ClickboxComponent) -> void:
	if not _is_that_slot(source):
		return
	
	EventBus.slot_cursor_left_button_clicked.emit(get_parent())


## Когда произошел правый клик по компоненту
func _on_mouse_right_button_clicked(source: ClickboxComponent) -> void:
	if not _is_that_slot(source):
		return
	
	EventBus.slot_cursor_right_button_clicked.emit(get_parent())


## Проверяет, является ли родительская нода источника этим слотом
func _is_that_slot(source: ClickboxComponent) -> bool:
	var source_parent = source.get_parent()
	if source_parent is not SlotBase:
		return false
	
	var source_card_node: SlotBase = source_parent
	var self_card_node: SlotBase = get_parent()
	return source_card_node == self_card_node
