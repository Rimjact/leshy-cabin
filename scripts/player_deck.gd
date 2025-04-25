class_name PlayerDeck
extends Node2D
## Класс с функционалом колод карточек игрока.


@export_group("Basic Properties")
## Тип колоды.
@export var type: Global.DeckType
## Счётчик карточек в колоде.
@export var label_counter: Label

@export_group("Cards")
## Массив карточек, находящихся в колоде.
@export var cards: Array[Card]


## to-do
func _ready() -> void:
	_subscribe_on_events()
	_fill_deck()


## Заполняет колоду картчоками.
func _fill_deck() -> void:
	match type:
		Global.DeckType.ANIMALS:
			_fill_animals_deck()
		Global.DeckType.SQUIRRELS:
			_fill_squirrels_deck()

	_update_label_counter()
	EventBus.deck_filled.emit(self)


## Заполняет колоду животных.
func _fill_animals_deck() -> void:
	for i in range(0, Global.DECK_ANIMALS_SIZE):
		_create_card_instance("ermine")


## Заполняет колоду белок.
func _fill_squirrels_deck() -> void:
	for i in range(0, Global.DECK_SQUIRRELS_SIZE):
		_create_card_instance("ermine")


## Когда игроку выдана карточка.
func _on_card_given(deck: PlayerDeck, _card: Card) -> void:
	if deck != self:
		return

	if cards.size() == 0:
		queue_free()
		return

	_update_label_counter()


## Создаёт экземпляр карточки.
func _create_card_instance(card_name: String) -> void:
	var card_scene_path: String = "res://objects/cards/object_card_{card_name}.tscn".format({"card_name": card_name})
	var card_scene: PackedScene = ResourceLoader.load(card_scene_path)
	var card_instance: Card = card_scene.instantiate() as Card

	var card_collider: CollisionShape2D = card_instance.get_node("ClickboxComponent/CollisionShape2D")
	card_collider.disabled = true

	add_child(card_instance)
	card_instance.global_position = self.global_position
	card_instance.visible = false
	card_instance.state = Global.CardState.IN_DECK
	cards.push_back(card_instance)


## Обновляет текст лэйбла счётчика с учётом
## текущего количества карточек в колоде.
func _update_label_counter() -> void:
	label_counter.text = var_to_str(cards.size())


## Когда на мышке нажата левая конопка мыши по компоненту.
func _on_mouse_left_button_clicked(source: ClickboxComponent) -> void:
	var source_parent = source.get_parent()
	if source_parent is not PlayerDeck:
		return

	var deck_node: PlayerDeck = source_parent
	if deck_node != self:
		return

	EventBus.deck_cursor_left_button_clicked.emit(self)


## Когда на мышке нажата правая конопка мыши по компоненту.
func _on_mouse_right_button_clicked(source: ClickboxComponent) -> void:
	var source_parent = source.get_parent()
	if source_parent is not PlayerDeck:
		return

	var deck_node: PlayerDeck = source_parent
	if deck_node != self:
		return

	EventBus.deck_cursor_right_button_clicked.emit(self)


## Подписывает на события.
func _subscribe_on_events() -> void:
	EventBus.deck_card_given.connect(_on_card_given)
