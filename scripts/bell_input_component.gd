class_name BellInputComponent
extends Node
## Класс звоночка для обработки ввода


## Курсор мыши навёлся на этот звоночек
func _on_mouse_entered() -> void:
	EventBus.card_cursor_entered.emit(get_parent())


## Курсор мыши ушёл от этого звоночка
func _on_mouse_exited() -> void:
	EventBus.card_cursor_exited.emit(get_parent())


## Когда произошел левый клик по компоненту
func _on_mouse_left_button_clicked(source: ClickboxComponent) -> void:
	if not _is_that_bell(source):
		return
	
	EventBus.card_cursor_left_button_clicked.emit(get_parent())


## Когда произошел правый клик по компоненту
func _on_mouse_right_button_clicked(source: ClickboxComponent) -> void:
	if not _is_that_bell(source):
		return
	
	EventBus.card_cursor_right_button_clicked.emit(get_parent())
	

## Проверяет, является ли родительская нода источника этого звоночка
func _is_that_bell(source: ClickboxComponent) -> bool:
	var source_parent = source.get_parent()
	if source_parent is not BellBase:
		return false
	
	var source_bell_node: BellBase = source_parent
	var self_bell_node: BellBase = get_parent()
	return source_bell_node == self_bell_node
