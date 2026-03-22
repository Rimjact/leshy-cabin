class_name CardAbilityTargetingDefault
extends CardAbilityTargeting
## Класс обычной способности краточки выбирать цели


## Возвращает один слот напротив карточки
func get_target_slots(card: CardBase, slot_id: int) -> Array[SlotBase]:
	var target_slots: Array[SlotBase] = []
	var opposite_slot: SlotBase = SlotsManager.get_card_opposite_slot(card, slot_id)
	target_slots.append(opposite_slot)
	
	return target_slots
