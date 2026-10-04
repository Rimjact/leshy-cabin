@abstract
class_name CardAbilityPreTurn
extends CardAbility
## Абстрактный класс способности карточки перед началом хода


@abstract
## Выполняет действия перед ходом карточки с указанного слота
func pre_turn(card: CardBase, from_slot_id: int) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	assert(owner is CardBase)
	
	if owner is CardBase:
		var card: CardBase = owner
		card.abilities_component.set_meta(&"CardAbilityPreTurn", self)


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	if owner is CardBase:
		var card: CardBase = owner
		card.remove_meta(&"CardAbilityPreTurn")
