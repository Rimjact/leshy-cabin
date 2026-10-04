class_name AttackCardInfo
## Класс информации об атаке карточки


## Количество урона
var damage: int
## Атакующая карточка
var attacker: CardBase
## Атакованная карточка
var victime_card: CardBase
## Атакованный слот
var victime_slot: SlotBase


func _init(dmg: int, atck: CardBase, vict_card: CardBase, vict_slot: SlotBase) -> void:
	self.damage = dmg
	self.attacker = atck
	self.victime_card = vict_card
	self.victime_slot = vict_slot
