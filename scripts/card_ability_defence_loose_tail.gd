class_name CardAbilityDefenceLooseTail
extends CardAbilityDefence
## Класс защитной способности "хвост на отсечение"


var _first_defence: bool = true


func _spawn_tail(on_slot: SlotBase, card_side: Global.BattleSide) -> CardBase:
	var tail_card_scene := Utils.get_card_scene_by_name("skink_tail")
	var tail_card := tail_card_scene.instantiate() as CardBase
	add_child(tail_card)
	tail_card.reparent(on_slot)
	tail_card.global_position = on_slot.global_position
	tail_card.state = Global.CardState.IN_SLOT
	tail_card.side = card_side
	on_slot.card = tail_card
	
	return tail_card


## Выполняет защитную способность "хвост на отсечение"
func defence(attack_info: AttackCardInfo) -> void:
	var damage_info := DamageInfo.new(attack_info.damage)
	var victime_card := attack_info.victime_card
	
	if not _first_defence:
		_first_defence = false
		EventBus.card_damaged.emit(victime_card, damage_info)
		return
	
	var victime_card_side := victime_card.side
	var victime_slot := attack_info.victime_slot
	var victime_slot_id: int = SlotsManager.get_slot_id(victime_slot)
	
	var empty_side_slots := SlotsManager.get_empty_side_slots(victime_slot_id, victime_card_side)
	if empty_side_slots.size() == 0:
		_first_defence = false
		EventBus.card_damaged.emit(victime_card, damage_info)
		return
	
	var random_target_slot: SlotBase = empty_side_slots.pick_random()
	EventBus.card_moved.emit(victime_card, victime_slot, random_target_slot)
	
	var tail_card := _spawn_tail(victime_slot, victime_card_side)
	EventBus.card_damaged.emit(tail_card, damage_info)
	
	_first_defence = false
