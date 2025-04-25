class_name AttackComponent
extends Node2D
## Класс компонента, отвечающего за атаку карточки.


## Количество урона, наносимого карточкой.
@export var damage: int
## Лэйбл счётчика.
@export var label_counter: Label


## Выполняет атаку.
func attack() -> void:
    pass