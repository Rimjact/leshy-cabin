extends Node
## Глобальный класс со вспомогательным функционалом


const CARD_SCENE: PackedScene = preload("res://objects/cards/node_card.tscn")
const CARD_DATA_DIR: String = "res://assets/cards/"


## Возвращает ресурс данных карточки по её идентификатору
func get_card_data(card_id: String) -> CardData:
	var card_data_path: String = CARD_DATA_DIR + card_id + ".tres"
	var card_data: CardData = load(card_data_path) as CardData
	return card_data


## Создаёт карточку и назначает ей ресурс данных
func create_card(card_data: CardData) -> CardBase:
	var card: CardBase = CARD_SCENE.instantiate() as CardBase
	card.card_data = card_data
	return card
