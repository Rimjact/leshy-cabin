class_name CardAbilityMovementHefty
extends CardAbilityMovement
## Абстрактный класс способности карточки здоровяк


## Направления движения карточки
enum MovementDirection {
	LEFT = 0,
	RIGHT = 1,
}


## Возвращает целевой идентификатор слота по направлению движения
func get_target_slot_id_by_direction(slot_id: int, direction: MovementDirection) -> int:
	match direction:
		MovementDirection.LEFT:
			return slot_id - 1
		MovementDirection.RIGHT:
			return slot_id + 1
		_:
			return slot_id


func move_from(card: CardBase, slot_id: int) -> void:
	var direction: MovementDirection = randi_range(0, 1) as MovementDirection
	var target_slot_id: int = get_target_slot_id_by_direction(slot_id, direction)
	if target_slot_id > 3 or target_slot_id < 0:
		return

	var card_side := card.side
	var target_slot := SlotsManager.get_slot_by_card_side(target_slot_id, card_side)
	if target_slot.card:
		var neigthbor_card := target_slot.card
		var n_c_slot := SlotsManager.get_slot_by_card_side(target_slot_id, card_side)
		
		var n_c_target_slot_id := get_target_slot_id_by_direction(target_slot_id, direction)
		var n_c_target_slot := SlotsManager.get_slot_by_card_side(n_c_target_slot_id, card_side)
		if n_c_target_slot.card:
			return
		
		EventBus.card_moved.emit(neigthbor_card, n_c_slot, n_c_target_slot)
	
	var last_slot := SlotsManager.get_slot_by_card_side(slot_id, card_side)
	EventBus.card_moved.emit(card, last_slot, target_slot)
