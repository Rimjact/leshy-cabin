class_name CardHealthComponent
extends Node2D
## Компонент здоровья карточки


## Очки здоровья
@export var health: int
## Счётчик очков здоровья на карточке
@export var counter_label: Label


## Когда карточка была вылечена
func _on_card_healed(card: CardBase, heal_info: HealInfo) -> void:
	if card != self:
		return
	
	heal(heal_info.value)


##
func _on_card_damaged(card: CardBase, damage_info: DamageInfo) -> void:
	if card != self:
		return
	
	damage(damage_info.value)


## Добавляет очки здоровья
func heal(value: int) -> void:
	health += value


## Отнимает очки здоровья
func damage(value: int) -> void:
	health -= value


## Подключает к сигналам Шины
func _connect_signals() -> void:
	EventBus.card_healed.connect(_on_card_healed)
