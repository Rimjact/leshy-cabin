class_name CardHealthComponent
extends Node2D
## Компонент здоровья карточки


## Очки здоровья
@export var health: int

@export_group("Components")
## Счётчик очков здоровья на карточке
@export var counter_label: Label


## Когда карточка была вылечена
func _on_card_healed(card: CardBase, heal_info: HealInfo) -> void:
	if card != get_parent():
		return
	
	heal(heal_info.value)


## Когда карточке нанесён урон
func _on_card_damaged(card: CardBase, damage_info: DamageInfo) -> void:
	if card != get_parent():
		return
	
	damage(damage_info.value)


## Когда здоровье карточки изменено
func _on_card_health_changed(card: CardBase, _old_value: int, new_value: int) -> void:
	if card != get_parent():
		return
	
	_update_counter(new_value)


## Добавляет очки здоровья
func heal(value: int) -> void:
	health += value


## Отнимает очки здоровья
func damage(value: int) -> void:
	health -= value


## Обновляет текст лэйбла счётчика
func _update_counter(new_value: int) -> void:
	counter_label.text = var_to_str(new_value)


## Подключает к сигналам Шины
func _connect_signals() -> void:
	EventBus.card_healed.connect(_on_card_healed)
