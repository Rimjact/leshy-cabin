class_name CardAbilityDefenceDefault
extends CardAbilityDefence
## Класс обычной способности карточки защищаться


## Выполняет обычную способность защиты карточки
func defence(card: CardBase, attack_info: AttackCardInfo) -> void:
	var damage: int = attack_info.damage
	var damage_info := DamageInfo.new(damage)
	EventBus.card_damaged.emit(card, damage_info)
