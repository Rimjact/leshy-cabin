class_name BellEyesLightComponent
extends PointLight2D
## Класс компонента света глаз звоночка


@export_group("Params")
## Цвета света глаз
@export var _eyes_light_colors: Array[Color]


## Когда состояние звоночка изменено
func _on_bell_state_changed(new_state: Global.BellState) -> void:
	var new_state_int: int = new_state
	var new_light_color: Color = _eyes_light_colors[new_state_int]
	print("color changed to " + var_to_str(new_light_color))
	_set_light_color(new_light_color)


## Устанавливает цвет света глаз звоночка
func _set_light_color(new_color: Color) -> void:
	color = new_color


## Присоединяет к сигналам Шины
func _connect_signals() -> void:
	EventBus.bell_state_changed.connect(_on_bell_state_changed)
