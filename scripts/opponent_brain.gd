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


class SacrificeCandidates:
	var squirrels: Array[CardBase] = []
	var others: Array[CardBase] = []
	var repeatable: CardBase = null


## Выбирает колоду, из которой противник возьмёт карту. null, если брать нечего
func choose_draw_deck(
	situation: OpponentSituation,
	animals_deck: DeckBase,
	squirrels_deck: DeckBase,
) -> DeckBase:
	var animals_ready: bool = _deck_has_cards(animals_deck)
	var squirrels_ready: bool = _deck_has_cards(squirrels_deck)
	if not animals_ready and not squirrels_ready:
		return null
	
	if _needs_squirrel(situation) and squirrels_ready:
		return squirrels_deck
	if animals_ready:
		return animals_deck
	if squirrels_ready:
		return squirrels_deck
	
	return null


## Возвращает лучшее действие или null, если ход пора сдавать
func choose_play(situation: OpponentSituation) -> Play:
	var board: OpponentBoard = OpponentBoard.capture()
	var best: Play = _best_animal_play(situation, board)
	if best:
		return best
	
	return _setup_squirrel(situation, board)


## Ищет самую выгодную животную карту, которую можно оплатить
func _best_animal_play(situation: OpponentSituation, board: OpponentBoard) -> Play:
	var best: Play = null
	var best_score: float = 0.0
	
	for card: CardBase in situation.hand:
		if not is_instance_valid(card) or card.is_squirrel():
			continue
		
		var payment: Payment = _payment_for(card, situation.bones, board.cards)
		if not payment.can_pay:
			continue
		
		for slot: SlotBase in _slots_opened_by(payment, board.empty_slots):
			var score: float = _score_play(card, slot, situation)
			if score <= best_score:
				continue
			
			best_score = score
			best = _make_play(card, slot, payment.sacrifices)
	
	return best


## Кладёт белку только чтобы потом принести её в жертву под сильную кровную карту
func _setup_squirrel(situation: OpponentSituation, board: OpponentBoard) -> Play:
	var squirrel: CardBase = _first_squirrel(situation.hand)
	if squirrel == null or board.empty_slots.is_empty():
		return null
	if not _has_blood_followup(situation, board, squirrel):
		return null
	
	var slot: SlotBase = _least_useful_slot(board.empty_slots, situation.advantage)
	var sacrifices: Array[CardBase] = []
	return _make_play(squirrel, slot, sacrifices)


func _has_blood_followup(
	situation: OpponentSituation,
	board: OpponentBoard,
	squirrel: CardBase,
) -> bool:
	var blood_ready: int = _sacrifice_capacity(board.cards)
	for card: CardBase in situation.hand:
		if card == squirrel or not is_instance_valid(card):
			continue
		if card.barter_component.currency != Global.BarterCurrency.VICTIMS:
			continue
		if card.barter_component.cost <= blood_ready:
			continue
		if _scores_on_empty_slot(card, board.empty_slots, situation):
			return true
	
	return false


func _scores_on_empty_slot(
	card: CardBase,
	empty_slots: Array[SlotBase],
	situation: OpponentSituation,
) -> bool:
	for slot: SlotBase in empty_slots:
		if _score_play(card, slot, situation) > 0.0:
			return true
	
	return false


func _score_play(card: CardBase, slot: SlotBase, situation: OpponentSituation) -> float:
	var lane: CardBase = _player_card_opposite(slot)
	return _score_lane(card, lane, situation.advantage) + _score_resources(card, situation)


func _score_lane(card: CardBase, lane: CardBase, advantage: int) -> float:
	if lane == null:
		return _score_empty_lane(card, advantage)
	
	return _score_occupied_lane(card, lane, advantage)


func _score_empty_lane(card: CardBase, advantage: int) -> float:
	var damage: float = card.damage_component.damage
	var lane_value: float = _empty_lane_value(advantage)
	if advantage <= -2:
		# Штраф слабого преимущества в ценности линии плоский и не умножается на урон
		return damage * (lane_value + 1.0) - 1.0
	
	return damage * lane_value


func _score_occupied_lane(card: CardBase, lane: CardBase, advantage: int) -> float:
	var our_damage: int = card.damage_component.damage
	var our_health: int = card.health_component.health
	var their_damage: int = lane.damage_component.damage
	var their_health: int = lane.health_component.health
	var score: float = 0.0
	
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
	
	return score


func _score_resources(card: CardBase, situation: OpponentSituation) -> float:
	var score: float = -card.barter_component.cost
	if situation.animals_left <= 2:
		score -= 2.0
	if situation.player_decks_empty:
		score += 2.0
	
	return score


func _payment_for(card: CardBase, bones: int, board: Array[CardBase]) -> Payment:
	var currency: Global.BarterCurrency = card.barter_component.currency
	var cost: int = card.barter_component.cost
	
	if currency == Global.BarterCurrency.FREE or cost <= 0:
		return _free_payment()
	if currency == Global.BarterCurrency.VICTIMS:
		return _pay_with_victims(cost, board)
	if currency == Global.BarterCurrency.BONES:
		return _pay_with_bones(cost, bones, board)
	
	return Payment.new()


func _free_payment() -> Payment:
	var payment := Payment.new()
	payment.can_pay = true
	return payment


func _pay_with_victims(cost: int, board: Array[CardBase]) -> Payment:
	var payment := Payment.new()
	payment.sacrifices = _pick_sacrifices(cost, board)
	payment.can_pay = payment.sacrifices.size() >= cost
	return payment


func _pay_with_bones(cost: int, bones: int, board: Array[CardBase]) -> Payment:
	var payment := Payment.new()
	if bones >= cost:
		payment.can_pay = true
		return payment
	
	var needed: int = ceili(float(cost - bones) / float(BONES_PER_SACRIFICE))
	payment.sacrifices = _pick_sacrifices(needed, board)
	payment.can_pay = payment.sacrifices.size() >= needed
	return payment


## Сначала белки, затем многократная жертва, затем самый слабый урон
func _pick_sacrifices(needed: int, board: Array[CardBase]) -> Array[CardBase]:
	var result: Array[CardBase] = []
	if needed <= 0:
		return result
	
	var candidates: SacrificeCandidates = _sacrifice_candidates(board)
	_take_sacrifices(result, candidates.squirrels, needed)
	if candidates.repeatable:
		while result.size() < needed:
			result.append(candidates.repeatable)
	_take_sacrifices(result, candidates.others, needed)
	return result


func _sacrifice_candidates(board: Array[CardBase]) -> SacrificeCandidates:
	var candidates := SacrificeCandidates.new()
	for card: CardBase in board:
		if not _can_sacrifice(card):
			continue
		if _is_repeatable_sacrifice(card):
			if candidates.repeatable == null:
				candidates.repeatable = card
		elif card.is_squirrel():
			candidates.squirrels.append(card)
		else:
			candidates.others.append(card)
	
	candidates.others.sort_custom(func(a: CardBase, b: CardBase) -> bool:
		return a.damage_component.damage < b.damage_component.damage
	)
	return candidates


func _take_sacrifices(result: Array[CardBase], cards: Array[CardBase], needed: int) -> void:
	for card: CardBase in cards:
		if result.size() >= needed:
			break
		result.append(card)


func _sacrifice_capacity(board: Array[CardBase]) -> int:
	var count: int = 0
	for card: CardBase in board:
		if not _can_sacrifice(card):
			continue
		if _is_repeatable_sacrifice(card):
			return 99
		count += 1
	
	return count


func _needs_squirrel(situation: OpponentSituation) -> bool:
	var cheapest_blood: int = _cheapest_blood_cost(situation.hand)
	var blood_ready: int = _sacrifice_capacity(OpponentBoard.capture().cards)
	return cheapest_blood >= 0 and blood_ready < cheapest_blood


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
	var player_card: CardBase = _player_card_opposite(slot)
	if player_card == null:
		return _empty_lane_value(advantage)
	
	var their_damage: float = player_card.damage_component.damage
	if advantage <= 0:
		return their_damage * 2.0
	
	return their_damage


## База 3, бонус при преимуществе от 3, плоский штраф при преимуществе до -2
func _empty_lane_value(advantage: int) -> float:
	var value: float = 3.0
	if advantage >= 3:
		value += 2.0
	if advantage <= -2:
		value -= 1.0
	
	return value


func _player_card_opposite(slot: SlotBase) -> CardBase:
	var slot_id: int = SlotsManager.get_opponent_slot_id(slot)
	return _live_card(SlotsManager.get_card_on_player_slot(slot_id))


## Пустые слоты и слоты, которые освободит эта оплата
func _slots_opened_by(payment: Payment, empty_slots: Array[SlotBase]) -> Array[SlotBase]:
	var slots: Array[SlotBase] = []
	slots.assign(empty_slots)
	
	for sacrifice: CardBase in payment.sacrifices:
		if not is_instance_valid(sacrifice) or _is_repeatable_sacrifice(sacrifice):
			continue
		
		var slot: SlotBase = SlotsManager.get_opponent_slot_of(sacrifice)
		if slot and not slots.has(slot):
			slots.append(slot)
	
	return slots


func _first_squirrel(hand: Array[CardBase]) -> CardBase:
	for card: CardBase in hand:
		if is_instance_valid(card) and card.is_squirrel():
			return card
	
	return null


func _can_sacrifice(card: CardBase) -> bool:
	return is_instance_valid(card) and card.abilities_component.has_sacriface_ability()


func _is_repeatable_sacrifice(card: CardBase) -> bool:
	var ability: CardAbilitySacriface = card.abilities_component.get_sacriface_ability()
	return ability is CardAbilitySacrifaceManyLives


func _deck_has_cards(deck: DeckBase) -> bool:
	return deck != null and is_instance_valid(deck) and not deck.cards.is_empty()


func _live_card(card: Variant) -> CardBase:
	if not is_instance_valid(card) or not card is CardBase:
		return null
	
	return card as CardBase


func _make_play(card: CardBase, slot: SlotBase, sacrifices: Array[CardBase]) -> Play:
	var play := Play.new()
	play.card = card
	play.slot = slot
	play.sacrifices = sacrifices
	return play
