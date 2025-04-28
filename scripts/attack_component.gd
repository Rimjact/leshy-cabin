class_name AttackComponent
extends Node2D
## Класс компонента, отвечающего за атаку карточки.


## Количество урона, наносимого карточкой.
@export var damage: int
## Лэйбл счётчика.
@export var label_counter: Label


## Выполняет атаку.
func attack() -> void:
    var attack_info := AttackInfo.new(damage, self.get_parent())
    EventBus.card_attack.emit(attack_info)