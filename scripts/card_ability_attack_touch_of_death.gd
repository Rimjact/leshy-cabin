class_name CardAbilityAttackTouchOfDeath
extends CardAbilityAttack
## Класс способности атаки "Прикосновение смерти" 


## One shot урон
var _one_shot_damage: int = 99


## Выполняет атаку по целевым слотам с указанным уроном убивая карточки одним ударом
func attack(card: CardBase, target_slots: Array[SlotBase]) -> void:
	for slot: SlotBase in target_slots:
		if slot.card:
			attack_slot(card, slot, _one_shot_damage)
		else:
			attack_slot(card, slot, card.damage_component.damage)
