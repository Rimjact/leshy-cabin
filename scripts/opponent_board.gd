class_name OpponentBoard
extends RefCounted
## Снимок слотов и карт противника на момент решения


## Пустые слоты противника
var empty_slots: Array[SlotBase] = []
## Живые карты на слотах противника
var cards: Array[CardBase] = []


## Снимает текущую сторону противника со стола
static func capture() -> OpponentBoard:
	var board := OpponentBoard.new()
	for slot: SlotBase in SlotsManager.opponent_slots:
		var card: CardBase = _live_card(slot.card)
		if card:
			board.cards.append(card)
		else:
			board.empty_slots.append(slot)
	
	return board


static func _live_card(card: Variant) -> CardBase:
	if not is_instance_valid(card) or not card is CardBase:
		return null
	
	return card as CardBase
