@abstract
class_name CardAbilityTargeting
extends CardAbility
## Абстрактный класс способности краточки выбирать цели


@abstract
## Возвращает один или несколько целевых слотов
func get_target_slots(card: CardBase, slot_id: int) -> Array[SlotBase]


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	owner.set_meta(&"CardAbilityTargeting", self)


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	owner.remove_meta(&"CardAbilityTargeting")
