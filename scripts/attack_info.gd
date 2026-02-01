class_name AttackInfo
extends Node
## Класс информации об атаке карточки


## Количество урона
var damage: int
## Атакующая карточка
var attacker: CardBase
## Атакованная карточка
var victime: CardBase


func _init(dmg: int, atck: CardBase, vict: CardBase) -> void:
	self.damage = dmg
	self.attacker = atck
	self.victime = vict
