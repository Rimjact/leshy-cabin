class_name AttackSlotInfo
## Класс информации об атаке слота


## Количество урона
var damage: int
## Атакующая карточка
var attacker: CardBase
## Атакованный слот
var victime_slot: SlotBase


func _init(dmg: int, atck: CardBase, vict_slot: SlotBase) -> void:
	self.damage = dmg
	self.attacker = atck
	self.victime_slot = vict_slot
