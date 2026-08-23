class_name CardBarterComponent
extends Node2D
## Класс компонента обмена карточки


## Валюта обмена карточки
@export var currency: Global.BarterCurrency = Global.BarterCurrency.FREE
## Стоимость в еденицах указанной валюты (от 0 до 4)
@export_range(0, 4, 1) var cost: int = 0

@export_group("Components")
## Нода стоимости в костях
@export var _bones_cost_node: Node2D
## Лэйбл стоимости в костях
@export var _bones_cost_lable: Label
## Нода стоимости в жертвах
@export var _victims_cost_node: Node2D
## Спрайты свтоимости в жертвах
@export var _victims_cost_sprites: Array[Sprite2D]


func _ready() -> void:
	_connect_signals()
	_show_cost()


## Показывает стоимость на карточке в текущей валюте обмена
func _show_cost() -> void:
	match currency:
		Global.BarterCurrency.VICTIMS:
			_show_victims_cost()
		Global.BarterCurrency.BONES:
			_show_bones_cost()


## Показывает стоимость на карточке в костях
func _show_bones_cost() -> void:
	_bones_cost_node.show()
	_bones_cost_lable.text = var_to_str(cost)


## Показывает стоимость на карточке в жертвах
func _show_victims_cost() -> void:
	_victims_cost_node.show()
	for i in range(0, cost):
		_victims_cost_sprites[i].show()


## Удаляет родительскую ноду карточки
func _delete_card() -> void:
	self.get_parent().queue_free()


## Когда карточка принесена в жертву
func _on_barter_card_sacrifaced(card: CardBase) -> void:
	var parent_card: CardBase = self.get_parent()
	if card != parent_card:
		return
	
	_delete_card()


## Подключает сигналы Шины
func _connect_signals() -> void:
	EventBus.barter_card_sacrifaced.connect(_on_barter_card_sacrifaced)
