class_name CardAbilityPreTurnFledgling
extends CardAbilityPreTurn
## Класс способности карточки детёныш 


## Идентификатор ресурса взрослой карточки
@export var adult_card_name: String = ""

var _first_turn: bool = true 


func pre_turn(card: CardBase, from_slot_id: int) -> bool:
	if _first_turn:
		_first_turn = false
		return true
	
	var card_side: Global.BattleSide = card.side
	var from_slot: SlotBase = SlotsManager.get_slot_by_card_side(from_slot_id, card_side)
	
	var adult_card := Utils.create_card(Utils.get_card_data(adult_card_name))
	place_card_on_slot(adult_card, from_slot, card_side)

	card.queue_free()
	return false
