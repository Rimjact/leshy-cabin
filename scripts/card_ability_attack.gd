@abstract
class_name CardAbilityAttack
extends CardAbility
## Абстрактный класс способности карточки атаковать


@abstract
## Выполняет атаку по целевым слотам
func attack(card: CardBase, target_slots: Array[SlotBase]) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	assert(owner is CardBase)
	
	if owner is CardBase:
		var card: CardBase = owner
		card.abilities_component.set_meta(&"CardAbilityAttack", self)


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	if owner is CardBase:
		var card: CardBase = owner
		card.remove_meta(&"CardAbilityAttack")
