class_name CardAbilitySacrifaceDefault
extends CardAbilitySacriface
## Класс обычной способности приношения в жертву краточки 


func sacriface(card: CardBase) -> void:
	card.queue_free()
