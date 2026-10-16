class_name DeckBase
extends Node2D
## Класс колоды


@export_group("Deck Properties")
## Тип колоды
@export var type: Global.DeckType = Global.DeckType.ANIMALS
## Сторона, которой принадлежит колода
@export var side: Global.BattleSide = Global.BattleSide.PLAYER

@export_group("Cards")
## Карточки в колоде
@export var cards: Array[CardBase]

## Может ли колода выдать карточку
var _can_issue_card: bool = false


var _logger: GameLogger


func _ready() -> void:
	_logger = Logging.create_logger(self.name)
	_logger.add_handler(Logging.create_console_handler())
	_logger.add_handler(Logging.create_file_handler())
	
	if side == Global.BattleSide.OPPONENT:
		_hide_counter()
		_disable_click()


## Когда произошел левый клик по колоде
func _on_deck_cursor_left_button_clicked(deck: DeckBase) -> void:
	if deck != self:
		return
	if side != Global.BattleSide.PLAYER:
		return
	if not _can_issue_card:
		return
	
	_give_card()


## Когда состояние игры изменено
func _on_game_state_changed(state: Global.GameState) -> void:
	if side != Global.BattleSide.PLAYER:
		return
	
	match state:
		Global.GameState.PLAYER_PICK_CARD:
			_unblock_card_issuance()
		Global.GameState.PLAYER_TURN:
			_block_card_issuance()


## Блокирует выдачу карточек
func _block_card_issuance() -> void:
	_can_issue_card = false


## Разблокирует выдачу карточек
func _unblock_card_issuance() -> void:
	_can_issue_card = true


## Начинает заполнение этой колоды
func _start_fill() -> void:
	EventBus.deck_fill_started.emit(self)


## Снимает верхнюю карточку и обновляет счётчик колоды
func take_card() -> CardBase:
	if cards.is_empty():
		return null
	
	var card: CardBase = cards.pop_back()
	EventBus.deck_cards_count_updated.emit(self)
	
	if cards.is_empty():
		EventBus.deck_was_empty.emit(self)
	
	return card


## Выдаёт карточку из колоды игроку
func _give_card() -> void:
	var card: CardBase = take_card()
	if card == null:
		return
	
	EventBus.player_card_added.emit(card)
	EventBus.deck_card_given.emit()


## Скрывает счётчик. Колоды противника его не показывают
func _hide_counter() -> void:
	var counter := get_node_or_null("DeckCounterComponent") as CanvasItem
	if counter:
		counter.visible = false


## Отключает клики. Колоду противника игрок не выбирает
func _disable_click() -> void:
	var clickbox := get_node_or_null("ClickboxComponent") as Area2D
	if clickbox == null:
		return
	
	clickbox.input_pickable = false
	clickbox.monitoring = false
	clickbox.monitorable = false


## Когда колода опустела
func _on_deck_was_empty(deck: DeckBase) -> void:
	if deck != self:
		return
	
	_logger.info("Колода пуста и удаляется")
	queue_free()


## Подключает к сигналам Шины
func _connect_signals() -> void:
	EventBus.deck_cursor_left_button_clicked.connect(_on_deck_cursor_left_button_clicked)
	EventBus.game_state_changed.connect(_on_game_state_changed)
	EventBus.deck_was_empty.connect(_on_deck_was_empty)
