class_name CardAbilityDefenceMightyLeap
extends CardAbilityDefence
## Класс защитной способности "Мощный прыжок" карточки



func receive(attack_info: AttackSlotInfo) -> AttackReception:
	var attacker := attack_info.attacker
	var attacker_abilities := attacker.abilities_component
	if attacker and attacker_abilities:
		var attack_ability := attacker_abilities.get_attack_ability()
		if attack_ability is CardAbilityAttackAirborne:
			return AttackReception.HIT_CARD

	return super.receive(attack_info)


## Выполняет защитную способность против летунов
func defence(attack_info: AttackCardInfo) -> void:
	var damage_info := DamageInfo.new(attack_info.damage)
	EventBus.card_damaged.emit(attack_info.victime_card, damage_info)
