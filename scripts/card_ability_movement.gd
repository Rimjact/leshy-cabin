@abstract
class_name CardAbilityMovement
extends CardAbility
## Абстрактный класс способности карточки перемещатся


@abstract
## Выполняет перемещение на слот
func move_from(card: CardBase, slot_id: int) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	register_ability(&"CardAbilityMovement")


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	unregister_ability(&"CardAbilityMovement")
