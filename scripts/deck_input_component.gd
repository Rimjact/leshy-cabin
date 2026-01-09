class_name DeckInputComponent
extends Node2D
## Класс колоды для обработки ввода


## Курсор мыши навёлся на эту колоду
func _on_mouse_entered() -> void:
	EventBus.deck_cursor_entered.emit(get_parent())


## Курсор мыши навёлся на эту колоду
func _on_mouse_exited() -> void:
	EventBus.deck_cursor_exited.emit(get_parent())


## Когда произошел левый клик по компоненту
func _on_mouse_left_button_clicked(source: ClickboxComponent) -> void:
	if not _is_that_deck(source):
		return
	
	EventBus.deck_cursor_left_button_clicked.emit(get_parent())


## Когда произошел правый клик по компоненту
func _on_mouse_right_button_clicked(source: ClickboxComponent) -> void:
	if not _is_that_deck(source):
		return
	
	EventBus.deck_cursor_right_button_clicked.emit(get_parent())


## Проверяет, является ли родительская нода источника этой колодой
func _is_that_deck(source: ClickboxComponent) -> bool:
	var source_parent = source.get_parent()
	if source_parent is not DeckBase:
		return false
	
	var source_deck_node: DeckBase = source_parent
	var self_deck_node: DeckBase = get_parent()
	return source_deck_node == self_deck_node
