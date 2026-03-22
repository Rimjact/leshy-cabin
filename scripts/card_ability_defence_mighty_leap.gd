class_name CardAbilityDefenceMightyLeap
extends CardAbilityDefence
## Класс защитной способности "Мощный прыжок" карточки


## Выполняет защитную способность против летунов
func defence(attack_info: AttackCardInfo) -> void:
	var damage_info := DamageInfo.new(attack_info.damage)
	EventBus.card_damaged.emit(attack_info.victime_card, damage_info)
