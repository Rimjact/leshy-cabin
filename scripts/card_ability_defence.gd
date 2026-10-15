@abstract
class_name CardAbilityDefence
extends CardAbility
## Абстрактный класс способности карточки защищаться


## Результат приема атаки
enum AttackReception {
	HIT_CARD, ## Карта была атакована
	PASS_TO_OWNER, ## Атака была передана владельцу карты
}


## Принимает атаку
func receive(attack_info: AttackSlotInfo) -> AttackReception:
	if attack_info.ignore_card:
		return AttackReception.PASS_TO_OWNER
	
	return AttackReception.HIT_CARD


## Выполняет способность защиты карточки
func defence(attack_info: AttackCardInfo) -> void:
	var damage_info := DamageInfo.new(attack_info.damage)
	EventBus.card_damaged.emit(attack_info.victime_card, damage_info)


## Вызывается перед выполнением хода карточки
func prepare_turn(_card: CardBase) -> void:
	pass


## Вызывается после выполнения хода карточки
func finish_turn(_card: CardBase) -> void:
	pass


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	register_ability(&"CardAbilityDefence")


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	unregister_ability(&"CardAbilityDefence")
