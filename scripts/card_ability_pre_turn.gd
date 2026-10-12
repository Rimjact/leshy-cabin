@abstract
class_name CardAbilityPreTurn
extends CardAbility
## Абстрактный класс способности карточки перед началом хода


@abstract
## Выполняет действия перед ходом карточки с указанного слота
func pre_turn(card: CardBase, from_slot_id: int) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	register_ability(&"CardAbilityPreTurn")


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	unregister_ability(&"CardAbilityPreTurn")
