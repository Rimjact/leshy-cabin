@abstract
class_name CardAbilitySacriface
extends CardAbility
## Абстрактный класс способности карточки приношения в жертву


@abstract
## Приносит в жертву карточку
func sacriface(card: CardBase) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	register_ability(&"CardAbilitySacriface")


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	unregister_ability(&"CardAbilitySacriface")
