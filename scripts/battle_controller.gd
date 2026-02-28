class_name BattleController
extends Node2D
## Класс контроллера битвы


## Таймер ожидания перед атакой карточки
@export var _card_attack_timer: Timer


## Когда состояние игры изменено
func _on_game_state_changed(new_state: Global.GameState) -> void:
	match new_state:
		Global.GameState.PLAYER_CARDS_ATTACK:
			force_player_cards_attack()
		Global.GameState.OPPONENT_CARDS_ATTACK:
			force_opponent_cards_attack()


## Выполняет атаку карточками игрока, находящимися в слотах
func force_player_cards_attack() -> void:
	var cur_slot_id: int = 0
	var player_slots: Array[SlotBase] = SlotsManager.player_slots
	
	for slot: SlotBase in player_slots:
		var card: CardBase = slot.card
		if not card:
			cur_slot_id += 1
			continue
		
		_card_attack_timer.start()
		await _card_attack_timer.timeout
		EventBus.battle_player_card_turn.emit(card, cur_slot_id)
		
		cur_slot_id += 1
	
	EventBus.battle_player_cards_attack_ended.emit()


## Выполняет атаку картчоками оппонента, находящимся на слотах
func force_opponent_cards_attack() -> void:
	var cur_slot_id: int = 0
	var opponent_slots: Array[SlotBase] = SlotsManager.opponent_slots
	
	for slot: SlotBase in opponent_slots:
		var card: CardBase = slot.card
		if not card:
			cur_slot_id += 1
			continue
		
		EventBus.battle_opponent_card_turn.emit(card, cur_slot_id)
		_card_attack_timer.start()
		await _card_attack_timer.timeout
		
		cur_slot_id += 1
	
	EventBus.battle_opponent_cards_attack_ended.emit()
