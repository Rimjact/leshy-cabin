@abstract
class_name CardAbilityTargeting
extends CardAbility
## Абстрактный класс способности краточки выбирать цели


@abstract
## Возвращает один или несколько целевых слотов
func get_target_slots(card: CardBase, slot_id: int) -> Array[SlotBase]


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	register_ability(&"CardAbilityTargeting")


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	unregister_ability(&"CardAbilityTargeting")
