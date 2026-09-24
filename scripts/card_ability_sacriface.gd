@abstract
class_name CardAbilitySacriface
extends CardAbility
## Абстрактный класс способности карточки приношения в жертву


@abstract
## Приносит в жертву карточку
func sacriface(card: CardBase) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	assert(owner is CardBase)
	
	if owner is CardBase:
		var card: CardBase = owner
		card.abilities_component.set_meta(&"CardAbilitySacriface", self)


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	if owner is CardBase:
		var card: CardBase = owner
		card.remove_meta(&"CardAbilitySacriface")
