class_name CardAbilityAttackDefault
extends CardAbilityAttack
## Класс обычной способности карточки атаковать


## Выполняет атаку по целевым слотам с указанным уроном
func attack(card: CardBase, target_slots: Array[SlotBase]) -> void:
	var damage: int = card.damage_component.damage
	
	for slot: SlotBase in target_slots:
		var attack_info := AttackSlotInfo.new(damage, card, slot)
		EventBus.slot_attacked.emit(attack_info)
