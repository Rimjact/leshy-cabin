class_name SlotBase
extends Node2D
## Класс слота для карточек

## Сторона слота
@export var side: Global.BattleSide = Global.BattleSide.PLAYER

## Карточка на слоте
@export var card: CardBase = null


var _logger: GameLogger


func _ready() -> void:
	_logger = Logging.create_logger(self.name)
	_logger.add_handler(Logging.create_console_handler())
	_logger.add_handler(Logging.create_file_handler())


## Когда произошел левый клик по слоту
func _on_slot_cursor_left_button_clicked(slot: SlotBase) -> void:
	if slot != self:
		return
	


## Когда карточка установлена на слот
func _on_slot_card_placed(slot: SlotBase, new_card: CardBase, _by_card_ability: bool) -> void:
	if slot != self:
		return
	
	card = new_card
	_logger.info("Новая карточка установлена: " + new_card.name)


## Когда слот атакован
func _on_slot_attacked(attack_info: AttackSlotInfo) -> void:
	if attack_info.victime_slot != self:
		return
	
	if not card:
		_redirect_attack_to_owner(attack_info.damage)
		return
	
	var defence_ability := card.abilities_component.get_defence_ability()
	var reception := CardAbilityDefence.AttackReception.HIT_CARD
	if defence_ability:
		reception = defence_ability.receive(attack_info)
	elif attack_info.ignore_card:
		reception = CardAbilityDefence.AttackReception.PASS_TO_OWNER
	
	match reception:
		CardAbilityDefence.AttackReception.HIT_CARD:
			_redirect_attack_to_card(attack_info)
		CardAbilityDefence.AttackReception.PASS_TO_OWNER:
			_redirect_attack_to_owner(attack_info.damage)


## Когда карточка уничтожена
func _on_card_destroyed(destroyed_card: CardBase) -> void:
	if destroyed_card != card:
		return
	
	card = null


## Когда карточка переместилась
func _on_card_moved(new_card: CardBase, from_slot: SlotBase, to_slot: SlotBase) -> void:
	if from_slot == self:
		card = null
		return
	
	if to_slot == self:
		card = new_card
		return


## Перенаправляет атаку на владельца слота
func _redirect_attack_to_owner(damage: int) -> void:
	match side:
		Global.BattleSide.PLAYER:
			_logger.info("Игроку нанесено {0} едениц урона".format([damage]))
			EventBus.battle_player_attacked.emit(damage)
		Global.BattleSide.OPPONENT:
			_logger.info("Оппоненту нанесено {0} едениц урона".format([damage]))
			EventBus.battle_opponent_attacked.emit(damage)


## Перенаправляет атаку на находящуюся в слоте карточку
func _redirect_attack_to_card(attack_info: AttackSlotInfo) -> void:
	var damage: int = attack_info.damage
	var attacker: CardBase = attack_info.attacker
	var victime: CardBase = card
	var slot: SlotBase = attack_info.victime_slot
	var attack_card_info := AttackCardInfo.new(damage, attacker, victime, slot)
	
	_logger.info("Перенаправление атаки на карточку {0}".format([card.name]))
	EventBus.card_attacked.emit(attack_card_info)


## Соединяет сигналы Шины
func _connect_signals() -> void:
	EventBus.slot_cursor_left_button_clicked.connect(_on_slot_cursor_left_button_clicked)
	EventBus.slot_card_placed.connect(_on_slot_card_placed)
	EventBus.slot_attacked.connect(_on_slot_attacked)
	EventBus.card_destroyed.connect(_on_card_destroyed)
	EventBus.card_moved.connect(_on_card_moved)
