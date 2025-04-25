class_name AbilityBase
extends Node2D
## Класс, отвечающий за базовый функционал способностей карточек.


## Имя способности.
@export var ability_name: String
## Координаты иконки способности.
@export var icon_rect: Rect2


func _ready() -> void:
    _subscribe_on_event()


## Перезаписываемый метод обработчика перехода карточки на слот.
func _on_card_moved_to_slot() -> void:
    pass


## Перезаписываемый метод обработчика атаки карточки.
func _on_card_attack() -> void:
    pass


## Перезаписываемый метод обработчика атаки на карточку.
func _on_card_attacked() -> void:
    pass


## Перезаписываемый метод обработчика конца хода игрока.
func _on_player_turn_end() -> void:
    pass


## Перезаписываемый метод обработчика начала хода игрока.
func _on_player_turn_start() -> void:
    pass


## Подписывает на события.
func _subscribe_on_event() -> void:
    pass