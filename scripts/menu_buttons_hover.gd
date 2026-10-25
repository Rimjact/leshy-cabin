extends VBoxContainer
## Плавно красит подпись кнопки в цвет огня, пока курсор над кнопкой.


## Цвет пламени свечей на столе.
@export var fire_color: Color = Color(1.0, 0.66515005, 0.33279657, 1.0)
## Длительность перехода цвета в секундах.
@export var fade_duration: float = 0.2

var _rest_colors: Dictionary = {}
var _tweens: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is TextureButton:
			_bind_button(child)


## Готовит подпись кнопки и подписывается на наведение.
func _bind_button(button: TextureButton) -> void:
	var caption := _caption_of(button)
	if caption == null:
		return
	
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var settings := caption.label_settings
	if settings == null:
		settings = LabelSettings.new()
		caption.label_settings = settings
	else:
		settings = settings.duplicate()
		caption.label_settings = settings
	
	_rest_colors[button] = settings.font_color
	button.mouse_entered.connect(_on_button_mouse_entered.bind(button))
	button.mouse_exited.connect(_on_button_mouse_exited.bind(button))


func _on_button_mouse_entered(button: TextureButton) -> void:
	_tween_caption(button, fire_color)


func _on_button_mouse_exited(button: TextureButton) -> void:
	if not _rest_colors.has(button):
		return
	_tween_caption(button, _rest_colors[button])


func _tween_caption(button: TextureButton, target: Color) -> void:
	var caption := _caption_of(button)
	if caption == null or caption.label_settings == null:
		return
	
	var active: Tween = _tweens.get(button)
	if active != null and active.is_valid():
		active.kill()
	
	var color_tween := create_tween()
	color_tween.set_trans(Tween.TRANS_SINE)
	color_tween.set_ease(Tween.EASE_IN_OUT)
	color_tween.tween_property(caption.label_settings, "font_color", target, fade_duration)
	_tweens[button] = color_tween


func _caption_of(button: TextureButton) -> Label:
	return button.get_node_or_null("Caption") as Label
