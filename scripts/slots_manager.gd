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


## Возвращает слот напротив указанных карточки и идентификтора слота
static func get_card_opposite_slot(card: CardBase, id: int) -> SlotBase:
	match card.side:
		Global.BattleSide.PLAYER:
			return get_opponent_slot(id)
		Global.BattleSide.OPPONENT:
			return get_player_slot(id)
		_:
			return null


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


## Возвращает карточку на слоте по стороне
static func get_card_on_slot_by_side(id: int, side: Global.BattleSide) -> CardBase:
	if not _is_valid_slot_id(id):
		return null
	
	match side:
		Global.BattleSide.PLAYER:
			return get_card_on_player_slot(id)
		Global.BattleSide.OPPONENT:
			return get_card_on_opponent_slot(id)
		_:
			return null


## Возвращает слоты слева и справа относительно слота с указанным ID
static func get_player_side_slots_relative_to(id: int) -> Array[SlotBase]:
	if not _is_valid_slot_id(id):
		return [null, null]
	
	var left_id: int = id - 1
	var right_id: int = id + 1
	
	var slots: Array[SlotBase] = []
	slots.append(get_player_slot(left_id))
	slots.append(get_player_slot(right_id))
	
	return slots


## Возвращает миссив слотов, которые содержат карточки со стороны игрока
static func get_player_side_slots_with_card() -> Array[SlotBase]:
	var slots: Array[SlotBase] = []
	
	for i in range(0, 4):
		var player_slot: SlotBase = get_player_slot(i)
		if player_slot.card:
			slots.append(player_slot)
	
	return slots


## Возвращает количество слотов, содержащие карточки со стороны игрока
static func get_player_side_slots_with_card_count() -> int:
	return get_player_side_slots_with_card().size()


## Возвращает слот основываясь на стороне карточки
static func get_slot_by_card_side(slot_id: int, card_side: Global.BattleSide) -> SlotBase:
	match card_side:
		Global.BattleSide.PLAYER:
			return get_player_slot(slot_id)
		Global.BattleSide.OPPONENT:
			return get_opponent_slot(slot_id)
		_:
			return null


## Возвращает id слота игрока по его экземпляру, вернёт -1 если не найден
static func get_player_slot_id(slot: SlotBase) -> int:
	var id: int = 0
	for ply_slot: SlotBase in player_slots: 
		if ply_slot == slot:
			return id
		id = id + 1
	
	return -1


## Возвращает id слота оппонента по его экземпляру, вернёт -1 если не найден
static func get_opponent_slot_id(slot: SlotBase) -> int:
	var id: int = 0
	for opponent_slot: SlotBase in opponent_slots:
		if opponent_slot == slot:
			return id
		id = id + 1
	
	return -1


## Возвращает id слота по его экземпляру, вернёт -1 если не найден
static func get_slot_id(slot: SlotBase) -> int:
	match slot.side:
		Global.BattleSide.PLAYER:
			return get_player_slot_id(slot)
		Global.BattleSide.OPPONENT:
			return get_opponent_slot_id(slot)
		_:
			return -1


## Возвращает слот слева, если он пуст и имеет верный id, иначе ничего
static func get_empty_left_slot(from_slot_id: int, side: Global.BattleSide) -> SlotBase:
	var left_slot_id: int = from_slot_id - 1
	if left_slot_id < 0:
		return null
	
	var left_slot := get_slot_by_card_side(left_slot_id, side)
	if left_slot.card:
		return null
	
	return left_slot


## Возвращает слот справа, если он пуст и имеет верный id, иначе ничего
static func get_empty_right_slot(from_slot_id: int, side: Global.BattleSide) -> SlotBase:
	var right_slot_id: int = from_slot_id + 1
	if right_slot_id > 3:
		return null
	
	var right_slot := SlotsManager.get_slot_by_card_side(right_slot_id, side)
	if right_slot.card:
		return null
	
	return right_slot


## Возвращает пустые боковые слоты
static func get_empty_side_slots(from_slot_id: int, side: Global.BattleSide) -> Array[SlotBase]:
	var empty_slots: Array[SlotBase] = []
	
	var left_empty_slot := get_empty_left_slot(from_slot_id, side)
	if left_empty_slot:
		empty_slots.append(left_empty_slot)
	
	var right_empty_slot := get_empty_right_slot(from_slot_id, side)
	if right_empty_slot:
		empty_slots.append(right_empty_slot)
	
	return empty_slots


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
