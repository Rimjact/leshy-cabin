class_name SlotBase
extends Node2D
## Класс слота для карточек

## Сторона слота
@export var side: Global.BattleSide = Global.BattleSide.PLAYER

## Карточка на слоте
var card: CardBase = null


## Когда произошел левый клик по слоту
func _on_slot_cursor_left_button_clicked(slot: SlotBase) -> void:
	if slot != self:
		return
	


## Когда карточка установлена на слот
func _on_slot_card_placed(slot: SlotBase, new_card: CardBase) -> void:
	if slot != self:
		return
	
	card = new_card


## Когда слот атакован
func _on_slot_attacked(attack_info: AttackSlotInfo) -> void:
	if attack_info.victime_slot != self:
		return
	
	if not card:
		_redirect_attack_to_owner(attack_info.damage)
		return
	
	_redirect_attack_to_card(attack_info)


## Перенаправляет атаку на владельца слота
func _redirect_attack_to_owner(damage: int) -> void:
	match side:
		Global.BattleSide.PLAYER:
			EventBus.battle_player_attacked.emit(damage)
			print("Игрок атакован: " + var_to_str(damage))
		Global.BattleSide.OPPONENT:
			EventBus.battle_opponent_attacked.emit(damage)
			print("Оппонент атакован: " + var_to_str(damage))


## Перенаправляет атаку на находящуюся в слоте карточку
func _redirect_attack_to_card(attack_info: AttackSlotInfo) -> void:
	var damage: int = attack_info.damage
	var attacker: CardBase = attack_info.attacker
	var victime: CardBase = card
	var attack_card_info := AttackCardInfo.new(damage, attacker, victime)
	
	EventBus.card_attacked.emit(attack_card_info)
	print("Атака перенаправлена на карточку: " + var_to_str(victime))


## Соединяет сигналы Шины
func _connect_signals() -> void:
	EventBus.slot_cursor_left_button_clicked.connect(_on_slot_cursor_left_button_clicked)
	EventBus.slot_card_placed.connect(_on_slot_card_placed)
	EventBus.slot_attacked.connect(_on_slot_attacked)
