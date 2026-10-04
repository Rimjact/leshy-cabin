@abstract
class_name CardAbilityAfterTurn
extends CardAbility
## Абстрактный класс способности карточки после завершения хода


@abstract
## Заканчивает ход карточки с указанного слота
func end_turn(card: CardBase, form_slot_id: int) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	assert(owner is CardBase)
	
	if owner is CardBase:
		var card: CardBase = owner
		card.abilities_component.set_meta(&"CardAbilityAfterTurn", self)


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	if owner is CardBase:
		var card: CardBase = owner
		card.remove_meta(&"CardAbilityAfterTurn")
