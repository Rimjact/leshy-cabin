class_name Card
extends Node2D
## Класс игровых карточек.


@export_group("Components")
@export var clickbox_component: ClickboxComponent
@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var ability_component: AbilityComponent

## Текущее состояние карточки.
var state: Global.CardState = Global.CardState.IN_DECK
## Текущий слот, на который помещена карточка.
var slot: PlayerCardSlot = null


## Когда курсор навёлся на эту карточку.
func on_mouse_entered() -> void:
	EventBus.card_cursor_entered.emit(self)


## Когда курсор ушёл от этой карточки.
func on_mouse_exited() -> void:
	EventBus.card_cursor_exited.emit(self)


## Когда на мышке нажата левая конопка мыши по компоненту.
func on_mouse_left_button_clicked(source: ClickboxComponent) -> void:
	var source_parent = source.get_parent()
	if source_parent is not Card:
		return

	var card_node: Card = source_parent
	if card_node != self:
		return

	EventBus.card_cursor_left_button_clicked.emit(self)


## Когда на мышке нажата правая конопка мыши по компоненту.
func on_mouse_right_button_clicked(source: ClickboxComponent) -> void:
	var source_parent = source.get_parent()
	if source_parent is not Card:
		return

	var card_node: Card = source_parent
	if card_node != self:
		return

	EventBus.card_cursor_right_button_clicked.emit(self)
