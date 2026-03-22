@abstract
class_name CardAbility
extends Node2D
## Абстрактный класс способности карточки


@export_category("Parameters")
## Область иконки способности
@export var _icon_region_rect: Rect2

@export_category("Components")
## Спрайт иконки способности
@export var _icon_sprite: Sprite2D


func _enter_tree() -> void:
	assert(owner is CardAbilitiesComponent)


func _ready() -> void:
	_update_icon(_icon_region_rect)


## Обновляет иконку на спрайте способности
func _update_icon(new_region_rect: Rect2) -> void:
	_icon_sprite.region_rect = new_region_rect
