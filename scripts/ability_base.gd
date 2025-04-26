class_name AbilityBase
extends Node2D
## Класс, отвечающий за базовый функционал способностей карточек.


## Имя способности.
@export var ability_name: String
## Координаты иконки способности.
@export var icon_rect: Rect2

## Карточка, которой пренадлежит способность.
@onready var card: Card = get_node("../../")
## Компонент здоровья карточки.
@onready var health_component: HealthComponent = get_node("../../HealthComponent")
## Компонент атаки карточки.
@onready var attack_component: AttackComponent = get_node("../../AttackComponent")
## Компонент способности карточки.
@onready var ability_component: AbilityComponent = get_node("../../AbilityComponent")


func _ready() -> void:
    _subscribe_on_event()


## Перезаписываемый метод обработчика перехода карточки на слот.
func _on_card_moved_to_slot() -> void:
    pass


## Перезаписываемый метод обработчика атаки карточки.
func _on_card_attack(attack_info: AttackInfo) -> void:
    pass


## Перезаписываемый метод обработчика атаки на карточку.
func _on_card_attacked(card: Card, attack_info: AttackInfo) -> void:
    pass


## Перезаписываемый метод обработчика начала хода игрока.
func _on_player_turn_start() -> void:
    pass


## Перезаписываемый метод обработчика конца хода игрока.
func _on_player_turn_end() -> void:
    pass


## Подписывает на события.
func _subscribe_on_event() -> void:
    EventBus.card_attack.connect(_on_card_attack)
    EventBus.card_attacked.connect(_on_card_attacked)