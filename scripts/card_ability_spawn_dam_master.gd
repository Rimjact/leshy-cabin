class_name CardAbilitySpawnDamMaster
extends CardAbilitySpawn
## Класс обычной способности мастера плотин


## Возвращает слот слева, если он пуст и имеет верный id, иначе ничего
func _get_empty_left_slot(from_slot_id: int, side: Global.BattleSide) -> SlotBase:
	var left_slot_id: int = from_slot_id - 1
	if left_slot_id < 0:
		return null
	
	var left_slot := SlotsManager.get_slot_by_card_side(left_slot_id, side)
	if left_slot.card:
		return null
	
	return left_slot


## Возвращает слот справа, если он пуст и имеет верный id, иначе ничего
func _get_empty_right_slot(from_slot_id: int, side: Global.BattleSide) -> SlotBase:
	var right_slot_id: int = from_slot_id + 1
	if right_slot_id > 3:
		return null
	
	var right_slot := SlotsManager.get_slot_by_card_side(right_slot_id, side)
	if right_slot.card:
		return null
	
	return right_slot


## Возвращает пустые боковые слоты
func _get_empty_side_slots(from_slot_id: int, side: Global.BattleSide) -> Array[SlotBase]:
	var empty_slots: Array[SlotBase] = []
	
	var left_empty_slot := _get_empty_left_slot(from_slot_id, side)
	if left_empty_slot:
		empty_slots.append(left_empty_slot)
	
	var right_empty_slot := _get_empty_right_slot(from_slot_id, side)
	if right_empty_slot:
		empty_slots.append(right_empty_slot)
	
	return empty_slots


func spawn_cards_from(summoner: CardBase, slot_id: int) -> void:
	var summoner_side: Global.BattleSide = summoner.side
	
	var empty_slots := _get_empty_side_slots(slot_id, summoner_side)
	for slot: SlotBase in empty_slots:
		var dam_card_scene := Utils.get_card_scene_by_name("dam")
		var dam_card := dam_card_scene.instantiate() as CardBase
		dam_card.global_position = slot.global_position
		dam_card.state = Global.CardState.IN_SLOT
		dam_card.side = summoner_side
		
		slot.card = dam_card
