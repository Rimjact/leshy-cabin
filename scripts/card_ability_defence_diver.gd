class_name CardAbilityDefenceDiver
extends CardAbilityDefence
## Класс защитной способности "Ныряльщик"


## Карточка находится под водой
var _submerged: bool = false


func receive(attack_info: AttackSlotInfo) -> AttackReception:
	if _submerged:
		return AttackReception.PASS_TO_OWNER
	
	return super.receive(attack_info)


## Перед ходом карточка выныривает
func prepare_turn(card: CardBase) -> void:
	_submerged = false
	card.set_face_down(false)


## После хода карточка ныряет и закрывается задней стороной
func finish_turn(card: CardBase) -> void:
	_submerged = true
	card.set_face_down(true)
