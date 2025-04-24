class_name Card
extends Node2D
## Класс игровых карточек.


## Текущее состояние карточки.
var state: Global.CardState = Global.CardState.IN_DECK


## Когда курсор навёлся на эту карточку.
func on_mouse_entered() -> void:
	EventBus.card_cursor_entered.emit(self)


## Когда курсор ушёл от этой карточки.
func on_mouse_exited() -> void:
	EventBus.card_cursor_exited.emit(self)
