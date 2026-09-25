@abstract
class_name CardAbilityMovement
extends CardAbility
## Абстрактный класс способности карточки перемещатся


@abstract
## Выполняет перемещение на слот
func move_to(card: CardBase, slot_id: int) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	assert(owner is CardBase)
	
	if owner is CardBase:
		var card: CardBase = owner
		card.abilities_component.set_meta(&"CardAbilityMovement", self)


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	if owner is CardBase:
		var card: CardBase = owner
		card.remove_meta(&"CardAbilityMovement")
