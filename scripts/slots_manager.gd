class_name SlotsManager
extends Node2D
## Класс менеджера слотов


## Узел слотов игрока
@export var player_slots_node: Node2D
## Узел слотов оппонента
@export var opponent_slots_node: Node2D

## Массив слотов игрока
static var player_slots: Array[SlotBase]
## Миссив слотов оппонента
static var opponent_slots: Array[SlotBase]


func _ready() -> void:
	_add_player_slots_to_array()
	_add_opponent_slots_to_array()


## Возвращает слот игрока по ID
static func get_player_slot(id: int) -> SlotBase:
	if not _is_valid_slot_id(id):
		return null
	
	return player_slots.get(id)


## Возвращает слот оппонента по ID
static func get_opponent_slot(id: int) -> SlotBase:
	if not _is_valid_slot_id(id):
		return null
	
	return opponent_slots.get(id)


## Возвращает карточку на слоте игрока по его ID
static func get_card_on_player_slot(id: int) -> CardBase:
	if not _is_valid_slot_id(id):
		return null
	
	var player_slot: SlotBase = player_slots.get(id)
	return player_slot.card


## Возвращает карточку на слоте оппонента по его ID
static func get_card_on_opponent_slot(id: int) -> CardBase:
	if not _is_valid_slot_id(id):
		return null
	
	var opponent_slot: SlotBase = opponent_slots.get(id)
	return opponent_slot.card


## Возвращает слоты слева и справа относительно слота с указанным ID
static func get_player_left_and_right_slots_relative_to(id: int) -> Array[SlotBase]:
	if not _is_valid_slot_id(id):
		return [null, null]
	
	var left_id: int = id - 1
	var right_id: int = id + 1
	
	var slots: Array[SlotBase] = []
	slots.append(get_player_slot(left_id))
	slots.append(get_player_slot(right_id))
	
	return slots


## Проверяет валидность указанного ID слота
static func _is_valid_slot_id(id: int) -> bool:
	if id < 0 or id > 3:
		return false
	
	return true


## Добавляет все слоты игрока в статический массив 
func _add_player_slots_to_array() -> void:
	var player_slots_nodes = player_slots_node.get_children()
	for slot_node in player_slots_nodes:
		if slot_node is not SlotBase:
			continue
		
		player_slots.append(slot_node) 


## Добавляет все слоты оппонента в статический массив
func _add_opponent_slots_to_array() -> void:
	var opponent_slots_nodes = opponent_slots_node.get_children()
	for slot_node in opponent_slots_nodes:
		if slot_node is not SlotBase:
			continue
		
		opponent_slots.append(slot_node)
