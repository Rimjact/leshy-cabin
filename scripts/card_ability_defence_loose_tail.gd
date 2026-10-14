class_name CardAbilityDefenceLooseTail
extends CardAbilityDefence
## Класс защитной способности "хвост на отсечение"


## Лишился хвоста
var _lost_tail: bool = false


func _spawn_tail(on_slot: SlotBase, card_side: Global.BattleSide) -> CardBase:
	var tail_card := Utils.create_card(Utils.get_card_data("skink_tail"))
	place_card_on_slot(tail_card, on_slot, card_side)
	
	return tail_card


func _update_skink_card_sprite(card: CardBase) -> void:
	var sprite: Sprite2D = card.get_node("AnimalSprite")
	sprite.region_rect = Rect2(45.0, 33.0, 43.0, 31.0)


## Выполняет защитную способность "хвост на отсечение"
func defence(attack_info: AttackCardInfo) -> void:
	var damage_info := DamageInfo.new(attack_info.damage)
	var victime_card := attack_info.victime_card
	
	if _lost_tail:
		EventBus.card_damaged.emit(victime_card, damage_info)
		return
	
	var victime_card_side := victime_card.side
	var victime_slot := attack_info.victime_slot
	var victime_slot_id: int = SlotsManager.get_slot_id(victime_slot)
	
	var empty_side_slots := SlotsManager.get_empty_side_slots(victime_slot_id, victime_card_side)
	if empty_side_slots.size() == 0:
		EventBus.card_damaged.emit(victime_card, damage_info)
		return
	
	var random_target_slot: SlotBase = empty_side_slots.pick_random()
	EventBus.card_moved.emit(victime_card, victime_slot, random_target_slot)
	
	_update_skink_card_sprite(victime_card)
	
	var tail_card := _spawn_tail(victime_slot, victime_card_side)
	EventBus.card_damaged.emit(tail_card, damage_info)
	
	_lost_tail = true
