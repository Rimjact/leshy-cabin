class_name DeckBase
extends Node2D
## Класс колоды


@export_group("Deck Properties")
## Тип колоды
@export var type: Global.DeckType = Global.DeckType.ANIMALS

@export_group("Cards")
## Карточки в колоде
@export var cards: Array[CardBase]


func _start_fill() -> void:
	EventBus.deck_fill_started.emit(self)
