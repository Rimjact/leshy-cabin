class_name DeckBase
extends Node2D
## Класс колоды


@export_group("Deck Properties")
## Тип колоды
@export var type: Global.DeckType = Global.DeckType.ANIMALS

@export_group("Cards")
## Карточки в колоде
@export var cards: Array[CardBase]

## Может ли колода выдать карточку
var _can_issue_card: bool = false


## Когда произошел левый клик по колоде
func _on_deck_cursor_left_button_clicked(deck: DeckBase) -> void:
	if deck != self:
		return
	if not _can_issue_card:
		return
	
	_give_card()


## Когда состояние игры изменено
func _on_game_state_changed(state: Global.GameState) -> void:
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


## Выдаёт карточку из колоды
func _give_card() -> void:
	var card: CardBase = cards.pop_back()
	EventBus.player_card_added.emit(card)
	EventBus.deck_cards_count_updated.emit(self)
	EventBus.deck_card_given.emit()
	
	if cards.size() == 0:
		queue_free()


## Подключает к сигналам Шины
func _connect_signals() -> void:
	EventBus.deck_cursor_left_button_clicked.connect(_on_deck_cursor_left_button_clicked)
	EventBus.game_state_changed.connect(_on_game_state_changed)
