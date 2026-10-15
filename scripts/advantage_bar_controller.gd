class_name AdvantageBarController
extends Node2D
## Контроллер полоски превосходства


## Тёмные сердца игрока
@export var player_dark_hearts: Dictionary[Sprite2D, PointLight2D]
## Тёмные сердца опонента
@export var opponent_dar_hearts: Dictionary[Sprite2D, PointLight2D]

## Спрайт указателя
@export var arrow_sprite: Sprite2D


## Показатель преимущества
var advantage: int:
    set(value):
        if value > 5:
            advantage = 5
            return
        if value < -5:
            advantage = -5
            return
        advantage = value
    get():
        return advantage



## Когда игрок атакован
func _on_battle_player_attacked(damage: int) -> void:
    advantage = advantage - damage


## Когда опонент атакован
func _on_battle_opponent_attacked(damage: int) -> void:
    advantage = advantage + damage


##
func _hide_all_hearts() -> void:
    for heart: Sprite2D in player_dark_hearts.keys():
        var light: PointLight2D = player_dark_hearts.get(heart)
        heart.hide()
        light.hide()



## Присоединяет сигналы Шины
func _connect_signals() -> void:
    EventBus.battle_player_attacked.connect(_on_battle_player_attacked)
    EventBus.battle_opponent_attacked.connect(_on_battle_opponent_attacked)