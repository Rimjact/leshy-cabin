class_name SlotBase
extends Node2D
## Класс слота для карточек


## Карточка на слоте
var card: CardBase = null


## Когда произошел левый клик по слоту
func _on_slot_cursor_left_button_clicked(slot: SlotBase) -> void:
	if slot != self:
		return
	


## Соединяет сигналы Шины
func _connect_signals() -> void:
	EventBus.slot_cursor_left_button_clicked.connect(_on_slot_cursor_left_button_clicked)
