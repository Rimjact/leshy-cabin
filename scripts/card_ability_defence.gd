@abstract
class_name CardAbilityDefence
extends CardAbility
## Абстрактный класс способности карточки защищаться


@abstract
## Выполняет способность защиты карточки
func defence(attack_info: AttackCardInfo) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	register_ability(&"CardAbilityDefence")


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	unregister_ability(&"CardAbilityDefence")
