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
	var player_slots: Array[SlotBase] = SlotsManager.player_slots
	
	for slot: SlotBase in player_slots:
		var card: CardBase = slot.card
		if not card:
			continue
		
		_card_attack_timer.start()
		await _card_attack_timer.timeout
		EventBus.battle_player_card_turn.emit(card)
	
	EventBus.battle_player_cards_attack_ended.emit()


## Выполняет атаку картчоками оппонента, находящимся на слотах
func force_opponent_cards_attack() -> void:
	var opponent_slots: Array[SlotBase] = SlotsManager.opponent_slots
	
	for slot: SlotBase in opponent_slots:
		var card: CardBase = slot.card
		if not card:
			continue
		
		_card_attack_timer.start()
		await _card_attack_timer.timeout
		EventBus.battle_opponent_card_turn.emit(card)
	
	EventBus.battle_opponent_cards_attack_ended.emit()
