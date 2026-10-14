@abstract
class_name CardAbilityAttack
extends CardAbility
## Абстрактный класс способности карточки атаковать


@abstract
## Выполняет атаку по целевым слотам
func attack(card: CardBase, target_slots: Array[SlotBase]) -> void


## Атакует слот указанным уроном. bypass_card пропускает карту на слоте
func attack_slot(card: CardBase, slot: SlotBase, damage: int, bypass_card: bool = false) -> void:
	var attack_info := AttackSlotInfo.new(damage, card, slot, bypass_card)
	EventBus.slot_attacked.emit(attack_info)


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	register_ability(&"CardAbilityAttack")


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	unregister_ability(&"CardAbilityAttack")
