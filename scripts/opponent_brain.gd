class_name OpponentBrain
extends RefCounted
## Простая оценка хода противника. Веса можно менять, не трогая сцену


## Сколько действий противник может сделать за один свой ход
const MAX_ACTIONS: int = 8
## Кости, которые даёт одна жертва
const BONES_PER_SACRIFICE: int = 2
## Целая карта ещё ударит в эту фазу, поэтому её дороже съесть
const KEEP_BONUS: float = 2.0


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


## Ищет животную карту, которая после жертвы всё ещё выгоднее нуля
func _best_animal_play(situation: OpponentSituation, board: OpponentBoard) -> Play:
	var best: Play = null
	var best_score: float = 0.0
	
	for card: CardBase in situation.hand:
		if not is_instance_valid(card) or card.is_squirrel():
			continue
		
		for payment: Payment in _payment_options(card, situation.bones, board.cards):
			for slot: SlotBase in _slots_opened_by(payment, board.empty_slots):
				if _wastes_healthy_card(card, slot, payment.sacrifices):
					continue
				
				var score: float = _net_score(card, slot, payment.sacrifices, situation)
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
	
	var slot: SlotBase = _squirrel_slot(board.empty_slots, situation.advantage)
	var sacrifices: Array[CardBase] = []
	return _make_play(squirrel, slot, sacrifices)


func _has_blood_followup(
	situation: OpponentSituation,
	board: OpponentBoard,
	squirrel: CardBase,
) -> bool:
	var blood_ready: int = _fuel_capacity(board.cards)
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


func _net_score(
	card: CardBase,
	slot: SlotBase,
	sacrifices: Array[CardBase],
	situation: OpponentSituation,
) -> float:
	return _score_play(card, slot, situation) - _sacrifice_loss(sacrifices, situation.advantage)


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


## Тело снимает весь удар по шкале. Бонус угрозы нужен, когда игрок не проигрывает
func _score_occupied_lane(card: CardBase, lane: CardBase, advantage: int) -> float:
	var our_damage: int = card.damage_component.damage
	var our_health: int = card.health_component.health
	var their_damage: int = lane.damage_component.damage
	var kills: bool = _kills_opposing(card, lane)
	var flies: bool = _is_airborne(lane)
	var score: float = 8.0 + their_damage if kills else our_damage
	
	if not flies and not kills:
		score += their_damage
		if their_damage > 0 and our_health <= their_damage:
			score -= 3.0
	
	if kills and not flies and our_health > their_damage:
		score += 4.0
	
	if advantage >= 0 and (not flies or kills):
		score += their_damage * 2.0
	
	return score


func _score_resources(card: CardBase, situation: OpponentSituation) -> float:
	var score: float = -card.barter_component.cost
	if situation.animals_left <= 2:
		score -= 2.0
	if situation.player_decks_empty:
		score += 2.0
	
	return score


## Ценность карты, которая уйдёт со стола. Белка и многократная жертва ничего не стоят
func _sacrifice_loss(sacrifices: Array[CardBase], advantage: int) -> float:
	var loss: float = 0.0
	for card: CardBase in _unique_cards(sacrifices):
		if card.is_squirrel() or _is_repeatable_sacrifice(card):
			continue
		loss += _board_card_value(card, advantage)
	
	return loss


func _board_card_value(card: CardBase, advantage: int) -> float:
	var value: float = _score_lane(card, _lane_of(card), advantage)
	if _is_doomed(card):
		if value > 0.0:
			value *= 0.5
		return value
	
	if _is_full_health(card):
		value += KEEP_BONUS
	
	return value


## Нельзя съесть целую карту ради равной или более слабой, если новая линия не убивает лучше
func _wastes_healthy_card(card: CardBase, slot: SlotBase, sacrifices: Array[CardBase]) -> bool:
	for sacrifice: CardBase in _unique_cards(sacrifices):
		if sacrifice.is_squirrel() or _is_repeatable_sacrifice(sacrifice):
			continue
		if not _is_full_health(sacrifice):
			continue
		if _is_strictly_stronger(card, sacrifice):
			continue
		if _upgrades_kill(card, slot, sacrifice):
			continue
		return true
	
	return false


func _is_strictly_stronger(card: CardBase, other: CardBase) -> bool:
	return card.damage_component.damage > other.damage_component.damage \
		or card.health_component.health > other.health_component.health


func _upgrades_kill(card: CardBase, slot: SlotBase, sacrifice: CardBase) -> bool:
	if not _kills_opposing(card, _player_card_opposite(slot)):
		return false
	
	return not _kills_opposing(sacrifice, _lane_of(sacrifice))


func _payment_options(card: CardBase, bones: int, board: Array[CardBase]) -> Array[Payment]:
	var currency: Global.BarterCurrency = card.barter_component.currency
	var cost: int = card.barter_component.cost
	
	if currency == Global.BarterCurrency.FREE or cost <= 0:
		return [_free_payment()]
	if currency == Global.BarterCurrency.VICTIMS:
		return _payments_for(_sacrifice_sets(cost, board))
	if currency == Global.BarterCurrency.BONES:
		return _payments_for(_bone_sacrifice_sets(cost, bones, board))
	
	var none: Array[Payment] = []
	return none


func _free_payment() -> Payment:
	var payment := Payment.new()
	payment.can_pay = true
	return payment


func _payments_for(sets: Array) -> Array[Payment]:
	var payments: Array[Payment] = []
	for sacrifices in sets:
		var payment := Payment.new()
		payment.can_pay = true
		payment.sacrifices.assign(sacrifices)
		payments.append(payment)
	
	return payments


func _bone_sacrifice_sets(cost: int, bones: int, board: Array[CardBase]) -> Array:
	if bones >= cost:
		return [_no_sacrifices()]
	
	var needed: int = ceili(float(cost - bones) / float(BONES_PER_SACRIFICE))
	return _sacrifice_sets(needed, board)


## Все способы набрать нужное число жертв. Сначала тела, потом многократная жертва
func _sacrifice_sets(needed: int, board: Array[CardBase]) -> Array:
	var sets: Array = []
	if needed <= 0:
		sets.append(_no_sacrifices())
		return sets
	
	var candidates: SacrificeCandidates = _sacrifice_candidates(board)
	var bodies: Array[CardBase] = []
	bodies.append_array(candidates.squirrels)
	bodies.append_array(candidates.others)
	
	if bodies.size() >= needed:
		_append_combinations(sets, bodies, needed, _no_sacrifices(), 0)
	
	if candidates.repeatable == null:
		return sets
	
	sets.append(_repeat_sacrifice(candidates.repeatable, needed))
	var take: int = mini(needed - 1, bodies.size())
	while take > 0:
		_append_padded_sets(sets, bodies, take, needed, candidates.repeatable)
		take -= 1
	
	return sets


func _append_padded_sets(
	sets: Array,
	bodies: Array[CardBase],
	take: int,
	needed: int,
	repeatable: CardBase,
) -> void:
	var partials: Array = []
	_append_combinations(partials, bodies, take, _no_sacrifices(), 0)
	var extra: int = needed - take
	for partial in partials:
		var padded: Array[CardBase] = []
		for card: CardBase in partial:
			padded.append(card)
		padded.append_array(_repeat_sacrifice(repeatable, extra))
		sets.append(padded)


func _append_combinations(
	sets: Array,
	bodies: Array[CardBase],
	needed: int,
	current: Array[CardBase],
	start: int,
) -> void:
	if current.size() == needed:
		sets.append(current.duplicate())
		return
	
	for index in range(start, bodies.size()):
		current.append(bodies[index])
		_append_combinations(sets, bodies, needed, current, index + 1)
		current.remove_at(current.size() - 1)


func _no_sacrifices() -> Array[CardBase]:
	var sacrifices: Array[CardBase] = []
	return sacrifices


func _repeat_sacrifice(card: CardBase, times: int) -> Array[CardBase]:
	var sacrifices: Array[CardBase] = []
	for _index in times:
		sacrifices.append(card)
	
	return sacrifices


func _unique_cards(cards: Array[CardBase]) -> Array[CardBase]:
	var unique: Array[CardBase] = []
	for card: CardBase in cards:
		if is_instance_valid(card) and not unique.has(card):
			unique.append(card)
	
	return unique


## Сначала белки, затем многократная жертва, затем обречённые и слабый урон
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
	
	candidates.others.sort_custom(_fodder_before)
	return candidates


## Обречённая карта дешевле жертвы, чем целая карта с тем же уроном
func _fodder_before(a: CardBase, b: CardBase) -> bool:
	var a_doomed: bool = _is_doomed(a)
	var b_doomed: bool = _is_doomed(b)
	if a_doomed != b_doomed:
		return a_doomed
	
	return a.damage_component.damage < b.damage_component.damage


## Белки, многократная жертва и карты, которые не переживут ответный удар
func _fuel_capacity(board: Array[CardBase]) -> int:
	var count: int = 0
	for card: CardBase in board:
		if not _can_sacrifice(card):
			continue
		if _is_repeatable_sacrifice(card):
			return 99
		if card.is_squirrel() or _is_doomed(card):
			count += 1
	
	return count


func _needs_squirrel(situation: OpponentSituation) -> bool:
	var cheapest_blood: int = _cheapest_blood_cost(situation.hand)
	var blood_ready: int = _fuel_capacity(OpponentBoard.capture().cards)
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


## Белка занимает линию без карты игрока, пока такая есть
func _squirrel_slot(empty_slots: Array[SlotBase], advantage: int) -> SlotBase:
	var calm: Array[SlotBase] = []
	for slot: SlotBase in empty_slots:
		if _player_card_opposite(slot) == null:
			calm.append(slot)
	
	if not calm.is_empty():
		return _least_useful_slot(calm, advantage)
	
	return _least_useful_slot(empty_slots, advantage)


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


func _lane_of(card: CardBase) -> CardBase:
	var slot: SlotBase = SlotsManager.get_opponent_slot_of(card)
	if slot == null:
		return null
	
	return _player_card_opposite(slot)


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


func _kills_opposing(card: CardBase, lane: CardBase) -> bool:
	if lane == null:
		return false
	if _is_lethal_touch(card):
		return true
	
	return card.damage_component.damage >= lane.health_component.health


## Ответный удар снимет карту: летун бьёт мимо, смертельное касание убивает сразу
func _is_doomed(card: CardBase) -> bool:
	var lane: CardBase = _lane_of(card)
	if lane == null or _is_airborne(lane):
		return false
	if _is_lethal_touch(lane):
		return true
	
	return lane.damage_component.damage >= card.health_component.health


func _is_full_health(card: CardBase) -> bool:
	return card.card_data != null and card.health_component.health >= card.card_data.health


func _is_airborne(card: CardBase) -> bool:
	return card.abilities_component.get_attack_ability() is CardAbilityAttackAirborne


func _is_lethal_touch(card: CardBase) -> bool:
	return card.abilities_component.get_attack_ability() is CardAbilityAttackTouchOfDeath


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
