class_name CardAttackComponent
extends Node2D
## Класс компонента атаки карточки


## Количество урона, который наносит карточка
@export var damage: int

@export_group("Components")
## Лэйбл счётчика
@export var label_counter: Label


## Выполняет атаку
func attack() -> void:
	pass
