class_name CardAbilityAttackAirborne
extends CardAbilityAttack
## Класс способности атаки "Летун"


## Выполняет атаку по целевым слотам с указанным уроном игнорируя карточки
func attack(card: CardBase, target_slots: Array[SlotBase]) -> void:
	var damage: int = card.damage_component.damage
	
	for slot: SlotBase in target_slots:
		var attack_info := AttackSlotInfo.new(damage, card, slot, true)
		EventBus.slot_attacked.emit(attack_info)
