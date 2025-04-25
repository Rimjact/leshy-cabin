class_name HealInfo
extends Node
## Класс с информацией о лечении карточки.


var value: int
var source: Card


## Конструтор.
func _init(val: int, src: Card) -> void:
    self.value = val
    self.source = src
