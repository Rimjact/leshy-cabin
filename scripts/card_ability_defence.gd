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


@abstract
## Выполняет способность защиты карточки
func defence(attack_info: AttackCardInfo) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	register_ability(&"CardAbilityDefence")


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	unregister_ability(&"CardAbilityDefence")
