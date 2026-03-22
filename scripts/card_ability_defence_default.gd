class_name CardAbilityDefenceDefault
extends CardAbilityDefence
## Класс обычной способности карточки защищаться


## Выполняет обычную способность защиты карточки
func defence(attack_info: AttackCardInfo) -> void:
	var damage_info := DamageInfo.new(attack_info.damage)
	EventBus.card_damaged.emit(attack_info.victime_card, damage_info)
