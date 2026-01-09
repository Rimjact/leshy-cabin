class_name DeckSpawnComponent
extends Node2D
##


##
func _on_deck_fill_started(deck: DeckBase) -> void:
	var parent_deck: DeckBase = get_parent()
	if parent_deck != deck:
		return
	
	_fill_deck(deck)


##
func _fill_deck(deck: DeckBase) -> void:
	var deck_type: Global.DeckType = deck.type
	match deck_type:
		Global.DeckType.ANIMALS:
			_fill_animals_deck(deck)
		Global.DeckType.SQUIRRELS:
			_fill_squirrels_deck(deck)
	
	EventBus.deck_fill_completed.emit(deck)


##
func _fill_animals_deck(deck: DeckBase) -> void:
	pass


##
func _fill_squirrels_deck(deck: DeckBase) -> void:
	pass


##
func _create_card_instance(card_name: String) -> void:
	pass
