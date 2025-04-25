class_name HealthComponent
extends Node2D
## Класс компонента, отвечающего за здоровье карточек.


## Текущее количество здоровья.
@export var health: int
## Лэйбл счётчика.
@export var label_counter: Label


## Лечит карточку.
func heal(heal_info: HealInfo) -> void:
    var old_health: int = health

    health += heal_info.value

    var card: Card = self.get_parent()
    var healer: Card = heal_info.source

    _update_counter_label_text()

    EventBus.card_healed.emit(card, healer)
    EventBus.card_health_changed.emit(card, old_health, health)


## Наносит урон карточке.
func take_damage(attack_info: AttackInfo) -> void:
    var old_health: int = health

    health = max(0, health - attack_info.damage)

    var card: Card = self.get_parent()

    _update_counter_label_text()

    EventBus.card_health_changed.emit(card, old_health, health)

    if health == 0:
        var killer: Card = attack_info.source
        EventBus.card_killed.emit(card, killer)


## Обновляет текст счётчика здоровья.
func _update_counter_label_text() -> void:
    label_counter.text = var_to_str(health)