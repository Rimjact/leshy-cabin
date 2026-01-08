class_name CardBase
extends Node2D
## Класс карточки


@export_group("Components")
@export var clickbox_component: ClickboxComponent

## Состояние карточки 
var state: Global.CardState = Global.CardState.IN_DECK


## Курсор мыши навёлся на эту карточку
func on_mouse_entered() -> void:
	## To-do
	pass


## Курсор мыши навёлся на эту карточку
func on_mouse_exited() -> void:
	# To-do
	pass


## Когда произошел левый клик по компоненту
func on_mouse_left_button_clicked(source: ClickboxComponent) -> void:
	if not _is_source_parent_equels_self(source):
		return
	
	pass


## Когда произошел правый клик по компоненту
func on_mouse_right_button_clicked(source: ClickboxComponent) -> void:
	if not _is_source_parent_equels_self(source):
		return
	
	pass


## Проверяет, является ли родительская нода источника этой карточкой
func _is_source_parent_equels_self(source: ClickboxComponent) -> bool:
	var source_parent = source.get_parent()
	if source_parent is not CardBase:
		return false
	
	var card_base_node: CardBase = source_parent
	return card_base_node == self
