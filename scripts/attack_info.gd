class_name AttackInfo
extends Node
## Класс с информацией об атаке.

## Количество урона.
var damage: int
## Источник атаки (другая карточка).
var source: Card


## Конструтор.
func _init(dmg: int, src: Card) -> void:
    self.damage = dmg
    self.source = src