extends Node
## Глобальный класс со вспомогательным функционалом


## Возвращает сцену карточки по её имени 
func _get_card_scene_by_name(card_name: String) -> PackedScene:
	var cards_path: String = "res://objects/cards/"
	var card_scene_name: String = "object_card_" + card_name + ".tscn"
	var card_scene_path: String = cards_path + card_scene_name
	var card_scene: PackedScene = ResourceLoader.load(card_scene_path)
	
	return card_scene
