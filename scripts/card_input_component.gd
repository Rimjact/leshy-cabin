class_name CardInputComponent
extends Node
## Класс карточки для обработки ввода


## Компонент ввода карточки
@export var clickbox_component: ClickboxComponent


## Курсор мыши навёлся на эту карточку
func _on_mouse_entered() -> void:
	EventBus.card_cursor_entered.emit(get_parent())


## Курсор мыши ушёл с этой карточки
func _on_mouse_exited() -> void:
	EventBus.card_cursor_exited.emit(get_parent())


## Когда произошел левый клик по компоненту
func _on_mouse_left_button_clicked(source: ClickboxComponent) -> void:
	if not _is_that_card(source):
		return
	
	EventBus.card_cursor_left_button_clicked.emit(get_parent())


## Когда произошел правый клик по компоненту
func _on_mouse_right_button_clicked(source: ClickboxComponent) -> void:
	if not _is_that_card(source):
		return
	
	EventBus.card_cursor_right_button_clicked.emit(get_parent())


## Включает возможность ввода
func enable_input() -> void:
	_set_input_disabled(false)


## Выключает возможность ввода
func disable_input() -> void:
	_set_input_disabled(true)


## Переключает возможност ввода
func _set_input_disabled(disabled: bool) -> void:
	var collider: CollisionShape2D = clickbox_component.get_child(0)
	collider.disabled = disabled


## Проверяет, является ли родительская нода источника этой карточкой
func _is_that_card(source: ClickboxComponent) -> bool:
	var source_parent = source.get_parent()
	if source_parent is not CardBase:
		return false
	
	var source_card_node: CardBase = source_parent
	var self_card_node: CardBase = get_parent()
	return source_card_node == self_card_node
