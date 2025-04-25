class_name AttackInfo
extends Node
## Класс с информацией об атаке.


var damage: int
var source: Card


## Конструтор.
func _init(dmg: int, src: Card) -> void:
    self.damage = dmg
    self.source = src