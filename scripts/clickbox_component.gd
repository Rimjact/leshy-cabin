class_name ClickboxComponent
extends Area2D
## Класс компонента для обработки нажатий кнопок мыши


## Вызывается, когда произошел левый клик по компоненту
signal mouse_left_button_clicked(source: ClickboxComponent)
## Вызывается, когда произошел правый клик по компоненту
signal mouse_right_button_clicked(source: ClickboxComponent)


## Обработчик события ввода
func _input_event(viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is not InputEventMouseButton:
		return
	
	var mouse_button: InputEventMouseButton = event
	if mouse_button.pressed:
		return
	
	match mouse_button.button_index:
		MOUSE_BUTTON_LEFT:
			emit_signal("mouse_left_button_clicked", self)
			viewport.set_input_as_handled()
		MOUSE_BUTTON_RIGHT:
			emit_signal("mouse_right_button_clicked", self)
			viewport.set_input_as_handled()
