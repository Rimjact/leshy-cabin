class_name BellSpriteComponent
extends Sprite2D
## Класс компонента спрайта звоночка


@export_group("Params")
## Regions спрайта звоночка
@export var _bell_sprite_regions: Array[Rect2]


## Когда состояние звоночка изменено
func _on_bell_state_changed(new_state: Global.BellState) -> void:
	var new_state_int: int = new_state
	var new_sprite_region: Rect2 = _bell_sprite_regions[new_state_int]
	_set_sprite_region(new_sprite_region)


## Устанавливает Region для спрайта
func _set_sprite_region(new_region: Rect2) -> void:
	region_rect = new_region


## Присоединяет к сигналам Шины
func _connect_signals() -> void:
	EventBus.bell_state_changed.connect(_on_bell_state_changed)
