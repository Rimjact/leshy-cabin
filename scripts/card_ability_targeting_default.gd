class_name CardAbilityTargetingDefault
extends CardAbilityTargeting
## Класс обычной способности краточки выбирать цели


## Возвращает один слот напротив карточки
func get_target_slots(card: CardBase, slot_id: int) -> Array[SlotBase]:
	var target_slots: Array[SlotBase] = []
	target_slots.append(SlotsManager.get_card_opposite_slot(card, slot_id))
	
	return target_slots
