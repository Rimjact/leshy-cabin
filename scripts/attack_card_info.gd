class_name AttackCardInfo
## Класс информации об атаке карточки


## Количество урона
var damage: int
## Атакующая карточка
var attacker: CardBase
## Атакованный слот
var victime_card: CardBase


func _init(dmg: int, atck: CardBase, vict_slot: CardBase) -> void:
	self.damage = dmg
	self.attacker = atck
	self.victime_slot = vict_slot
