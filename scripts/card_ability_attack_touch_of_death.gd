class_name CardAbilityAttackTouchOfDeath
extends CardAbilityAttack
## Класс способности атаки "Прикосновение смерти" 


## One shot урон
var _one_shot_damage: int = 99


## Выполняет атаку по целевым слотам с указанным уроном убивая карточки одним ударом
func attack(card: CardBase, target_slots: Array[SlotBase]) -> void:
	for slot: SlotBase in target_slots:
		if slot.card:
			var one_shot_attack_info := AttackSlotInfo.new(_one_shot_damage, card, slot)
			EventBus.slot_attacked.emit(one_shot_attack_info)
		else:
			var attack_info := AttackSlotInfo.new(card.damage_component.damage, card, slot)
			EventBus.slot_attacked.emit(attack_info)
