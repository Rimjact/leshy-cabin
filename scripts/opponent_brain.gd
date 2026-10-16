class_name OpponentBrain
extends RefCounted
## Простая оценка хода противника. Веса можно менять, не трогая сцену


## Сколько действий противник может сделать за один свой ход
const MAX_ACTIONS: int = 8
## Кости, которые даёт одна жертва
const BONES_PER_SACRIFICE: int = 2


class Play:
	var card: CardBase
	var slot: SlotBase
	var sacrifices: Array[CardBase] = []


class Payment:
	var can_pay: bool = false
	var sacrifices: Array[CardBase] = []


## Выбирает колоду, из которой противник возьмёт карту. null, если брать нечего
func choose_draw_deck(
	hand: Array[CardBase],
	advantage: int,
	animals_deck: DeckBase,
	squirrels_deck: DeckBase,
) -> DeckBase:
	var animals_ready: bool = _deck_has_cards(animals_deck)
	var squirrels_ready: bool = _deck_has_cards(squirrels_deck)
	if not animals_ready and not squirrels_ready:
		return null
	
	var cheapest_blood: int = _cheapest_blood_cost(hand)
	var blood_ready: int = _sacrifice_capacity(_board_cards())
	var needs_squirrel: bool = cheapest_blood >= 0 and blood_ready < cheapest_blood
	if needs_squirrel and squirrels_ready:
		return squirrels_deck
	
	var victims_are_enough: bool = cheapest_blood < 0 or blood_ready >= cheapest_blood
	if animals_ready and (advantage < 0 or victims_are_enough):
		return animals_deck
	if animals_ready:
		return animals_deck
	if squirrels_ready:
		return squirrels_deck
	
	return null


## Возвращает лучшее действие или null, если ход пора сдавать
func choose_play(
	hand: Array[CardBase],
	advantage: int,
	bones: int,
	animals_left: int,
	player_decks_empty: bool,
) -> Play:
	var empty_slots: Array[SlotBase] = _empty_opponent_slots()
	var board: Array[CardBase] = _board_cards()
	var best: Play = null
	var best_score: float = 0.0
	
	for card: CardBase in hand:
		if not is_instance_valid(card) or _is_squirrel(card):
			continue
		
		var payment: Payment = _payment_for(card, bones, board)
		if not payment.can_pay:
			continue
		
		for slot: SlotBase in _slots_opened_by(payment, empty_slots):
			var score: float = _score_play(card, slot, advantage, animals_left, player_decks_empty)
			if score <= best_score:
				continue
			
			best_score = score
			best = Play.new()
			best.card = card
			best.slot = slot
			best.sacrifices = payment.sacrifices
	
	if best:
		return best
	
	return _setup_squirrel(hand, advantage, animals_left, player_decks_empty, empty_slots, board)


## Кладёт белку только чтобы потом принести её в жертву под сильную кровную карту
func _setup_squirrel(
	hand: Array[CardBase],
	advantage: int,
	animals_left: int,
	player_decks_empty: bool,
	empty_slots: Array[SlotBase],
	board: Array[CardBase],
) -> Play:
	var squirrel: CardBase = _first_squirrel(hand)
	if squirrel == null or empty_slots.is_empty():
		return null
	
	var blood_ready: int = _sacrifice_capacity(board)
	var has_followup: bool = false
	for card: CardBase in hand:
		if card == squirrel or not is_instance_valid(card):
			continue
		if card.barter_component.currency != Global.BarterCurrency.VICTIMS:
			continue
		if card.barter_component.cost <= blood_ready:
			continue
		
		for slot: SlotBase in empty_slots:
			var score: float = _score_play(card, slot, advantage, animals_left, player_decks_empty)
			if score > 0.0:
				has_followup = true
				break
		
		if has_followup:
			break
	
	if not has_followup:
		return null
	
	var play := Play.new()
	play.card = squirrel
	play.slot = _least_useful_slot(empty_slots, advantage)
	return play


func _score_play(
	card: CardBase,
	slot: SlotBase,
	advantage: int,
	animals_left: int,
	player_decks_empty: bool,
) -> float:
	var slot_id: int = SlotsManager.get_opponent_slot_id(slot)
	var lane: CardBase = _live_card(SlotsManager.get_card_on_player_slot(slot_id))
	var our_damage: int = card.damage_component.damage
	var our_health: int = card.health_component.health
	var score: float = 0.0
	
	if lane == null:
		score += our_damage * 3.0
		if advantage >= 3:
			score += our_damage * 2.0
		if advantage <= -2:
			score -= 1.0
	else:
		var their_damage: int = lane.damage_component.damage
		var their_health: int = lane.health_component.health
		if our_damage >= their_health:
			score += 8.0 + their_damage
		else:
			score += our_damage
		if advantage <= 0:
			score += their_damage * 2.0
		if our_health <= their_damage:
			score -= 3.0
		if our_damage >= their_health and our_health > their_damage:
			score += 4.0
	
	score -= card.barter_component.cost
	if animals_left <= 2:
		score -= 2.0
	if player_decks_empty:
		score += 2.0
	
	return score


func _payment_for(card: CardBase, bones: int, board: Array[CardBase]) -> Payment:
	var payment := Payment.new()
	var currency: Global.BarterCurrency = card.barter_component.currency
	var cost: int = card.barter_component.cost
	
	if currency == Global.BarterCurrency.FREE or cost <= 0:
		payment.can_pay = true
		return payment
	
	if currency == Global.BarterCurrency.VICTIMS:
		payment.sacrifices = _pick_sacrifices(cost, board)
		payment.can_pay = payment.sacrifices.size() >= cost
		return payment
	
	if currency == Global.BarterCurrency.BONES:
		if bones >= cost:
			payment.can_pay = true
			return payment
		
		var needed: int = ceili(float(cost - bones) / float(BONES_PER_SACRIFICE))
		payment.sacrifices = _pick_sacrifices(needed, board)
		payment.can_pay = payment.sacrifices.size() >= needed
		return payment
	
	return payment


## Сначала белки, затем многократная жертва, затем самый слабый урон
func _pick_sacrifices(needed: int, board: Array[CardBase]) -> Array[CardBase]:
	var result: Array[CardBase] = []
	if needed <= 0:
		return result
	
	var squirrels: Array[CardBase] = []
	var others: Array[CardBase] = []
	var repeatable: CardBase = null
	
	for card: CardBase in board:
		if not _can_sacrifice(card):
			continue
		if _is_repeatable_sacrifice(card):
			if repeatable == null:
				repeatable = card
		elif _is_squirrel(card):
			squirrels.append(card)
		else:
			others.append(card)
	
	others.sort_custom(func(a: CardBase, b: CardBase) -> bool:
		return a.damage_component.damage < b.damage_component.damage
	)
	
	for card: CardBase in squirrels:
		if result.size() >= needed:
			break
		result.append(card)
	
	if repeatable:
		while result.size() < needed:
			result.append(repeatable)
	
	for card: CardBase in others:
		if result.size() >= needed:
			break
		result.append(card)
	
	return result


func _sacrifice_capacity(board: Array[CardBase]) -> int:
	var count: int = 0
	for card: CardBase in board:
		if not _can_sacrifice(card):
			continue
		if _is_repeatable_sacrifice(card):
			return 99
		count += 1
	
	return count


func _cheapest_blood_cost(hand: Array[CardBase]) -> int:
	var cheapest: int = -1
	for card: CardBase in hand:
		if not is_instance_valid(card):
			continue
		if card.barter_component.currency != Global.BarterCurrency.VICTIMS:
			continue
		
		var cost: int = card.barter_component.cost
		if cheapest < 0 or cost < cheapest:
			cheapest = cost
	
	return cheapest


func _least_useful_slot(empty_slots: Array[SlotBase], advantage: int) -> SlotBase:
	var chosen: SlotBase = empty_slots[0]
	var chosen_value: float = _lane_value(chosen, advantage)
	for slot: SlotBase in empty_slots:
		var value: float = _lane_value(slot, advantage)
		if value < chosen_value:
			chosen = slot
			chosen_value = value
	
	return chosen


func _lane_value(slot: SlotBase, advantage: int) -> float:
	var slot_id: int = SlotsManager.get_opponent_slot_id(slot)
	var player_card: CardBase = _live_card(SlotsManager.get_card_on_player_slot(slot_id))
	if player_card == null:
		var value: float = 3.0
		if advantage >= 3:
			value += 2.0
		if advantage <= -2:
			value -= 1.0
		return value
	
	var their_damage: float = player_card.damage_component.damage
	if advantage <= 0:
		return their_damage * 2.0
	
	return their_damage


## Пустые слоты и слоты, которые освободит эта оплата
func _slots_opened_by(payment: Payment, empty_slots: Array[SlotBase]) -> Array[SlotBase]:
	var slots: Array[SlotBase] = []
	slots.assign(empty_slots)
	
	for sacrifice: CardBase in payment.sacrifices:
		if not is_instance_valid(sacrifice) or _is_repeatable_sacrifice(sacrifice):
			continue
		
		var slot: SlotBase = _slot_of(sacrifice)
		if slot and not slots.has(slot):
			slots.append(slot)
	
	return slots


func _slot_of(card: CardBase) -> SlotBase:
	for slot: SlotBase in SlotsManager.opponent_slots:
		if is_instance_valid(slot.card) and slot.card == card:
			return slot
	
	return null


func _empty_opponent_slots() -> Array[SlotBase]:
	var slots: Array[SlotBase] = []
	for slot: SlotBase in SlotsManager.opponent_slots:
		if _live_card(slot.card) == null:
			slots.append(slot)
	
	return slots


func _board_cards() -> Array[CardBase]:
	var cards: Array[CardBase] = []
	for slot: SlotBase in SlotsManager.opponent_slots:
		var card: CardBase = _live_card(slot.card)
		if card:
			cards.append(card)
	
	return cards


func _first_squirrel(hand: Array[CardBase]) -> CardBase:
	for card: CardBase in hand:
		if is_instance_valid(card) and _is_squirrel(card):
			return card
	
	return null


func _can_sacrifice(card: CardBase) -> bool:
	return is_instance_valid(card) and card.abilities_component.has_sacriface_ability()


func _is_repeatable_sacrifice(card: CardBase) -> bool:
	var ability: CardAbilitySacriface = card.abilities_component.get_sacriface_ability()
	return ability is CardAbilitySacrifaceManyLives


func _is_squirrel(card: CardBase) -> bool:
	if card == null or card.card_data == null:
		return false
	
	return card.card_data.resource_path.get_file() == "squirrel.tres"


func _deck_has_cards(deck: DeckBase) -> bool:
	return deck != null and is_instance_valid(deck) and not deck.cards.is_empty()


func _live_card(card: Variant) -> CardBase:
	if not is_instance_valid(card) or not card is CardBase:
		return null
	
	return card as CardBase
