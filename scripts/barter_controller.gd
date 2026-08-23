class_name BarterController
extends Node2D
## Класс контроллера обмена карточек


var _logger: GameLogger


func _ready() -> void:
	_logger = Logging.create_logger(self.name)
	_logger.add_handler(Logging.create_console_handler())
	_logger.add_handler(Logging.create_file_handler())


## Когда карточка выбрана
func _on_card_selected(card: CardBase) -> void:
	if _is_card_currency_victims(card):
		_enter_to_sacriface_mode(card)


## Когда снят выбор с карточки
func _on_card_deselected(card: CardBase) -> void:
	if _is_card_currency_victims(card):
		_exit_from_sacriface_mode()


## Когда левая кнопка мыши нажата по карточке
func _on_card_cursor_left_button_clicked(card: CardBase) -> void:
	if not _is_can_sacrifaced(card):
		return
	
	EventBus.barter_card_sacrifaced.emit(card)


## Когда карточка установлена на слот
func _on_slot_card_placed(slot: SlotBase, card: CardBase) -> void:
	pass


## Когда игрок вошел в режим жертваприношения
func _on_barter_sacriface_mode_entered(card: CardBase) -> void:
	pass


## Когда игрок вышел из режима жертваприношения
func _on_barter_sacriface_mode_exited() -> void:
	pass


## Когда обмен карточки завершён
func _on_barter_card_completed(card: CardBase) -> void:
	return


## Вернёт true, если валюта обмена у карточку равна жертвам
func _is_card_currency_victims(card: CardBase) -> bool:
	return card.barter_component.currency == Global.BarterCurrency.VICTIMS


## Вернёт true, если карточка может быть принесена в жертву сейчас 
func _is_can_sacrifaced(card: CardBase) -> bool:
	if card.side != Global.BattleSide.PLAYER:
		return false
	if GameStateController.get_current_state() != Global.GameState.PLAYER_TURN:
		return false
	if card.state != Global.CardState.IN_SLOT:
		return false
	
	return true 


## Входит в режим жертваприношения
func _enter_to_sacriface_mode(card: CardBase) -> void:
	_logger.info("Игрок вошел в режим жертваприношения")
	EventBus.barter_sacriface_mode_entered.emit(card) 


## Выходит из режима жертваприношения
func _exit_from_sacriface_mode() -> void:
	_logger.info("Игрок вышел из режима жертваприношения")
	EventBus.barter_sacriface_mode_exited.emit()


## Соединяет сигналы Шины
func _connect_signals() -> void:
	EventBus.card_selected.connect(_on_card_selected)
	EventBus.slot_card_placed.connect(_on_slot_card_placed)
	EventBus.barter_sacriface_mode_entered.connect(_on_barter_sacriface_mode_entered)
	EventBus.barter_sacriface_mode_exited.connect(_on_barter_sacriface_mode_exited)
