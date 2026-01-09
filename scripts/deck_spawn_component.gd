class_name DeckSpawnComponent
extends Node2D
## Класс спаунера карточек колоды


## Когда заполнение колоды карточками начато
func _on_deck_fill_started(deck: DeckBase) -> void:
	var parent_deck: DeckBase = get_parent()
	if parent_deck != deck:
		return
	
	_fill_deck(deck)


## Заполняет колоду
func _fill_deck(deck: DeckBase) -> void:
	var deck_type: Global.DeckType = deck.type
	match deck_type:
		Global.DeckType.ANIMALS:
			_fill_animals_deck(deck)
		Global.DeckType.SQUIRRELS:
			_fill_squirrels_deck(deck)
	
	EventBus.deck_fill_completed.emit(deck)
	EventBus.deck_cards_count_updated.emit(deck)


## Заполнет колоду животных
func _fill_animals_deck(deck: DeckBase) -> void:
	for i in range(0, Global.DECK_ANIMALS_SIZE_COUNT):
		_create_card_instance(deck, "ermine")


## Заполняет колоду белок
func _fill_squirrels_deck(deck: DeckBase) -> void:
	for i in range(0, Global.DECK_SQUIRRELS_SIZE_COUNT):
		_create_card_instance(deck, "ermine")


## Создаёт карточку по её имени и добавляет к колоде
func _create_card_instance(deck: DeckBase, card_name: String) -> void:
	var card_scene := Utils.get_card_scene_by_name(card_name)
	
	var card_instance := card_scene.instantiate() as CardBase
	add_child(card_instance)
	card_instance.global_position = self.global_position
	card_instance.card_input_component.disable_input()
	card_instance.visible = false
	card_instance.state = Global.CardState.IN_DECK
	
	deck.cards.push_back(card_instance)


## Подключает к сигналам Шины
func _connect_signals() -> void:
	EventBus.deck_fill_started.connect(_on_deck_fill_started)
