class_name AbilityComponent
extends Node2D
## Класс компонента, отвечающего за способность карточки.


## Нода способности карточки.
@export var ability: AbilityBase
## Спрайт иконки.
@export var icon_sprite: Sprite2D


func _ready() -> void:
    update_icon()


## Обновляет иконку способности.
func update_icon() -> void:
    icon_sprite.region_rect = ability.icon_rect