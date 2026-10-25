class_name MenuDeckButtonHover
extends TextureButton
## Плавно увеличивает размер кнопки деки, пока курсор над кнопкой.


func _ready() -> void:
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)


## Когда курсор мыши навёлся 
func _on_mouse_entered() -> void:
    _tween_size(Vector2(1.1, 1.1))


## Когда курсор мыши снял наведение
func _on_mouse_exited() -> void:
    _tween_size(Vector2(1.0, 1.0))


## Плавно изменяет размер кнопки
func _tween_size(target_size: Vector2) -> void:
    var color_tween := create_tween()
    color_tween.set_ease(Tween.EASE_OUT)
    color_tween.tween_property(self, "scale", target_size, 0.1)