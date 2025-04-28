class_name AbilityDefault
extends AbilityBase
## Класс стандартной способности карточки.


func _on_card_moved_to_slot() -> void:
    pass


func _on_card_attack(attack_info: AttackInfo) -> void:
    if attack_info.source != card:
        return

    print("Card " + attack_info.source.to_string() + " attack by default pattern!")
    ## default attack pattern to-do


func _on_card_attacked(card: Card, attack_info: AttackInfo) -> void:
    pass


func _on_player_turn_start() -> void:
    pass


func _on_player_turn_end() -> void:
    pass