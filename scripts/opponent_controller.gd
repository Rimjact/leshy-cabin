class_name OpponentController
extends Node2D
## Ход противника: взятие карты, оплата и выкладка на свои слоты


@export var animals_deck: DeckBase
@export var squirrels_deck: DeckBase
@export var player_animals_deck: DeckBase
@export var player_squirrels_deck: DeckBase
@export var hand: OpponentCardsController
@export var battle: BattleController
@export var action_timer: Timer

## Кости противника. Игроку они не показываются
var bones: int = 0

var _brain: OpponentBrain = OpponentBrain.new()
var _logger: GameLogger


func _ready() -> void:
	_logger = Logging.create_logger(self.name)
	_logger.add_handler(Logging.create_console_handler())
	_logger.add_handler(Logging.create_file_handler())
	
	if action_timer:
		action_timer.wait_time = 0.35
		action_timer.one_shot = true


## Когда состояние игры изменено
func _on_game_state_changed(new_state: Global.GameState) -> void:
	match new_state:
		Global.GameState.OPPONENT_PICK_CARD:
			_pick_card()
		Global.GameState.OPPONENT_TURN:
			_play_turn()


## Берёт одну карту или сообщает, что взять нечего
func _pick_card() -> void:
	var deck: DeckBase = _brain.choose_draw_deck(
		hand.cards,
		battle.advantage,
		_live_deck(animals_deck),
		_live_deck(squirrels_deck),
	)
	if deck:
		var card: CardBase = deck.take_card()
		if card:
			card.side = Global.BattleSide.OPPONENT
			EventBus.opponent_card_added.emit(card)
			_logger.info("Противник взял карту")
	
	EventBus.opponent_pick_resolved.emit()


## Разыгрывает карты, затем сдаёт ход
func _play_turn() -> void:
	await _wait_action()
	
	var actions: int = 0
	while actions < OpponentBrain.MAX_ACTIONS:
		if not _is_opponent_turn():
			return
		
		var play: OpponentBrain.Play = _brain.choose_play(
			hand.cards,
			battle.advantage,
			bones,
			_deck_size(_live_deck(animals_deck)),
			_player_decks_empty(),
		)
		if play == null:
			break
		
		_execute_play(play)
		actions += 1
		await _wait_action()
	
	if _is_opponent_turn():
		_logger.info("Противник сдаёт ход")
		EventBus.bell_move_passed.emit()


func _execute_play(play: OpponentBrain.Play) -> void:
	for sacrifice: CardBase in play.sacrifices:
		if is_instance_valid(sacrifice):
			_sacrifice(sacrifice)
	
	var card: CardBase = play.card
	if not is_instance_valid(card):
		return
	
	if card.barter_component.currency == Global.BarterCurrency.BONES:
		bones -= card.barter_component.cost
	
	card.side = Global.BattleSide.OPPONENT
	EventBus.slot_card_placed.emit(play.slot, card, false)
	_logger.info("Противник разыграл карту на слот " + play.slot.name)


## Приносит карту в жертву, не начисляя кости игроку
func _sacrifice(card: CardBase) -> void:
	var slot: SlotBase = _slot_with(card)
	var ability: CardAbilitySacriface = card.abilities_component.get_sacriface_ability()
	var stays: bool = ability is CardAbilitySacrifaceManyLives
	if ability:
		ability.sacriface(card)
	
	bones += OpponentBrain.BONES_PER_SACRIFICE
	if slot and not stays:
		slot.card = null


func _slot_with(card: CardBase) -> SlotBase:
	for slot: SlotBase in SlotsManager.opponent_slots:
		if is_instance_valid(slot.card) and slot.card == card:
			return slot
	
	return null


func _wait_action() -> void:
	if action_timer == null or not is_inside_tree():
		return
	
	action_timer.start()
	await action_timer.timeout


func _is_opponent_turn() -> bool:
	return is_inside_tree() and GameStateController.get_current_state() == Global.GameState.OPPONENT_TURN


func _player_decks_empty() -> bool:
	return _deck_size(_live_deck(player_animals_deck)) == 0 and _deck_size(_live_deck(player_squirrels_deck)) == 0


func _deck_size(deck: DeckBase) -> int:
	if deck == null:
		return 0
	
	return deck.cards.size()


func _live_deck(deck: Variant) -> DeckBase:
	if not is_instance_valid(deck) or not deck is DeckBase:
		return null
	
	return deck as DeckBase


## Присоединяет к сигналам Шины
func _connect_signals() -> void:
	EventBus.game_state_changed.connect(_on_game_state_changed)
