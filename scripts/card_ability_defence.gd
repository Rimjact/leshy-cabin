@abstract
class_name CardAbilityDefence
extends CardAbility
## Абстрактный класс способности карточки защищаться


@abstract
## Выполняет способность защиты карточки
func defence(card: CardBase, attack_info: AttackCardInfo) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	assert(owner is CardBase)
	
	if owner is CardBase:
		var card: CardBase = owner
		card.abilities_component.set_meta(&"CardAbilityDefence", self)


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	if owner is CardBase:
		var card: CardBase = owner
		card.remove_meta(&"CardAbilityDefence")
