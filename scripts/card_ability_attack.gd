@abstract
class_name CardAbilityAttack
extends CardAbility
## Абстрактный класс способности карточки атаковать


@abstract
## Выполняет атаку по целевым слотам
func attack(target_slots: Array[SlotBase], damage: int) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	owner.set_meta(&"CardAbilityAttack", self)


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	owner.remove_meta(&"CardAbilityAttack")
