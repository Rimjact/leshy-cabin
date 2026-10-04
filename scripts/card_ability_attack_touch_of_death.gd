class_name CardAbilityAttackTouchOfDeath
extends CardAbilityAttack
## Класс способности атаки "Прикосновение смерти" 


## Выполняет атаку по целевым слотам с указанным уроном убивая карточки одним ударом
func attack(card: CardBase, target_slots: Array[SlotBase]) -> void:
	var damage: int = card.damage_component.damage
	
	for slot: SlotBase in target_slots:
		if slot.card:
			damage = 99
		
		var attack_info := AttackSlotInfo.new(damage, card, slot)
		EventBus.slot_attacked.emit(attack_info)
