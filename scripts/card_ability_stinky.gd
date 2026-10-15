class_name CardAbilityStinky
extends CardAbility
## Класс способности "Вонючка"


## Слот напротив карточки, на котором действует дебафф
var _debuffed_slot: SlotBase = null
## Карточка, с которой сейчас снят 1 урон
var _affected_card: CardBase = null


func _enter_tree() -> void:
	register_ability(&"CardAbilityStinky")
	if not EventBus.slot_card_placed.is_connected(_on_slot_card_placed):
		EventBus.slot_card_placed.connect(_on_slot_card_placed)
	if not EventBus.card_moved.is_connected(_on_card_moved):
		EventBus.card_moved.connect(_on_card_moved)
	if not EventBus.card_destroyed.is_connected(_on_card_destroyed):
		EventBus.card_destroyed.connect(_on_card_destroyed)


func _exit_tree() -> void:
	_clear_affected()
	_debuffed_slot = null
	if EventBus.slot_card_placed.is_connected(_on_slot_card_placed):
		EventBus.slot_card_placed.disconnect(_on_slot_card_placed)
	if EventBus.card_moved.is_connected(_on_card_moved):
		EventBus.card_moved.disconnect(_on_card_moved)
	if EventBus.card_destroyed.is_connected(_on_card_destroyed):
		EventBus.card_destroyed.disconnect(_on_card_destroyed)
	unregister_ability(&"CardAbilityStinky")


## Когда карточка установлена на слот
func _on_slot_card_placed(slot: SlotBase, card: CardBase) -> void:
	if card == get_owner_card():
		_activate_opposite(slot)
		return
	
	if slot == _debuffed_slot:
		_affect(card)


## Когда карточка переместилась
func _on_card_moved(card: CardBase, from_slot: SlotBase, to_slot: SlotBase) -> void:
	if card == get_owner_card():
		_activate_opposite(to_slot)
		return
	
	if card == _affected_card and from_slot == _debuffed_slot and to_slot != _debuffed_slot:
		_clear_affected()
	
	if to_slot == _debuffed_slot:
		_affect(card)


## Когда карточка уничтожена
func _on_card_destroyed(card: CardBase) -> void:
	if card == get_owner_card():
		_clear_affected()
		_debuffed_slot = null
		return
	
	if card == _affected_card:
		_clear_affected()


## Включает дебафф на слоте напротив указанного
func _activate_opposite(own_slot: SlotBase) -> void:
	var opposite := _opposite_slot(own_slot)
	_debuffed_slot = opposite
	var card_on_slot: CardBase = null
	if opposite:
		card_on_slot = opposite.card
	_affect(card_on_slot)


## Вешает дебафф на карточку. Повторно на ту же карточку не вешается
func _affect(card: CardBase) -> void:
	if card == _affected_card:
		return
	
	_clear_affected()
	if card == null or not is_instance_valid(card) or card.damage_component == null:
		return
	
	_affected_card = card
	card.damage_component.add_stink_source()


## Снимает дебафф с карточки и возвращает ей прежний урон
func _clear_affected() -> void:
	if _affected_card != null and is_instance_valid(_affected_card) and _affected_card.damage_component:
		_affected_card.damage_component.remove_stink_source()
	
	_affected_card = null


## Возвращает слот напротив указанного
func _opposite_slot(slot: SlotBase) -> SlotBase:
	if slot == null:
		return null
	
	var slot_id := SlotsManager.get_slot_id(slot)
	match slot.side:
		Global.BattleSide.PLAYER:
			return SlotsManager.get_opponent_slot(slot_id)
		Global.BattleSide.OPPONENT:
			return SlotsManager.get_player_slot(slot_id)
		_:
			return null
