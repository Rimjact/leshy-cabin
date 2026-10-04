class_name CardAbilityPreTurnFledgling
extends CardAbilityPreTurn
## Класс способности карточки детёныш 


## Имя взрослой карточки
@export var adult_card_name: String = ""

var _first_turn: bool = true 


func pre_turn(card: CardBase, from_slot_id: int) -> void:
	if _first_turn:
		_first_turn = false
		return
	
	var card_side: Global.BattleSide = card.side
	var from_slot: SlotBase = SlotsManager.get_slot_by_card_side(from_slot_id, card_side)
	
	var adult_card_scene := Utils.get_card_scene_by_name(adult_card_name)
	var adult_card := adult_card_scene.instantiate() as CardBase
	add_child(adult_card)
	adult_card.reparent(from_slot)
	adult_card.global_position = from_slot.global_position
	adult_card.state = Global.CardState.IN_SLOT
	adult_card.side = card_side
	from_slot.card = adult_card
	
	card.queue_free()
