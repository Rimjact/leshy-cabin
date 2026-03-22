class_name AttackSlotInfo
## Класс информации об атаке слота


## Количество урона
var damage: int
## Атакующая карточка
var attacker: CardBase
## Атакованный слот
var victime_slot: SlotBase
## Игнорировать карточку на слоте
var ignore_card: bool


func _init(dmg: int, atck: CardBase, vict_slot: SlotBase, ignore_crd: bool = false) -> void:
	self.damage = dmg
	self.attacker = atck
	self.victime_slot = vict_slot
	self.ignore_card = ignore_crd
