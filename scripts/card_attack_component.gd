class_name CardAttackComponent
extends Node2D
## Класс компонента атаки карточки


## Количество урона, который наносит карточка
@export var damage: int

@export_group("Components")
## Лэйбл счётчика
@export var counter_label: Label


## Выполняет атаку
func attack(target: CardBase) -> void:
	var attack_info := AttackInfo.new(damage, get_parent(), target)
	EventBus.card_attack.emit(attack_info)


## Обновляет текст лэйбла счётчика
func _update_counter(new_value: int) -> void:
	counter_label.text = var_to_str(new_value)
