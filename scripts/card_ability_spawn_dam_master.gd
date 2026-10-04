class_name CardAbilitySpawnDamMaster
extends CardAbilitySpawn
## Класс обычной способности мастера плотин


func spawn_cards_from(summoner: CardBase, slot_id: int) -> void:
	var summoner_side: Global.BattleSide = summoner.side
	
	var empty_slots := SlotsManager.get_empty_side_slots(slot_id, summoner_side)
	for slot: SlotBase in empty_slots:
		var dam_card_scene := Utils.get_card_scene_by_name("dam")
		var dam_card := dam_card_scene.instantiate() as CardBase
		add_child(dam_card)
		dam_card.reparent(slot)
		dam_card.global_position = slot.global_position
		dam_card.state = Global.CardState.IN_SLOT
		dam_card.side = summoner_side
		slot.card = dam_card
