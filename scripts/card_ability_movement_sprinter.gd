class_name CardAbilityMovementSprinter
extends CardAbilityMovement
## Абстрактный класс способности карточки бегун


## Направления движения карточки
enum MovementDirection {
	LEFT = 0,
	RIGHT = 1,
}


func move_from(card: CardBase, slot_id: int) -> void:
	var direction: MovementDirection = randi_range(0, 1) as MovementDirection
	var target_slot_id: int = slot_id
	if direction == MovementDirection.LEFT:
		target_slot_id = target_slot_id - 1
	else:
		target_slot_id = target_slot_id + 1

	if target_slot_id > 3 or target_slot_id < 0:
		return

	var card_side := card.side
	var target_slot := SlotsManager.get_slot_by_card_side(target_slot_id, card_side)
	if target_slot.card:
		return
	
	var last_slot := SlotsManager.get_slot_by_card_side(slot_id, card_side)
	EventBus.card_moved.emit(card, last_slot, target_slot)
