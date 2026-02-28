class_name CardAttackComponent
extends Node2D
## Класс компонента атаки карточки


## Количество урона, который наносит карточка
@export var damage: int

@export_group("Components")
## Лэйбл счётчика
@export var counter_label: Label


func _ready() -> void:
	_update_counter(damage)


## Выполняет атаку
func attack(target_slot: SlotBase) -> void:
	var attack_info := AttackSlotInfo.new(damage, get_parent(), target_slot)
	EventBus.card_attack_slot.emit(attack_info)


## Обновляет текст лэйбла счётчика
func _update_counter(new_value: int) -> void:
	counter_label.text = var_to_str(new_value)
