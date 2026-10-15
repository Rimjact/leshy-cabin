@abstract
class_name CardAbility
extends Node2D
## Абстрактный класс способности карточки


## Является ли способность уникальной
@export var is_unique: bool = false

var _registered_card: CardBase


## Устанавливает карточку на слот с указанной стороной
func place_card_on_slot(card: CardBase, slot: SlotBase, side: Global.BattleSide) -> void:
	add_child(card)
	card.reparent(slot)
	card.global_position = slot.global_position
	card.scale = Vector2(1.0, 1.0)
	card.state = Global.CardState.IN_SLOT
	card.side = side
	EventBus.slot_card_placed.emit(slot, card)


## Возвращает карточку-владельца по цепочке родителей
func get_owner_card() -> CardBase:
	var current: Node = self
	while current:
		if current is CardBase:
			return current as CardBase
		current = current.get_parent()
	
	return null


## Регистрирует способность в компоненте карточки
func register_ability(ability_name: StringName) -> void:
	var card := get_owner_card()
	assert(card != null)
	assert(card.abilities_component != null)
	
	_registered_card = card
	card.abilities_component.set_meta(ability_name, self)


## Снимает регистрацию, если этот узел всё ещё занимает слот способности
func unregister_ability(ability_name: StringName) -> void:
	if _registered_card == null or not is_instance_valid(_registered_card):
		_registered_card = null
		return
	
	var abilities := _registered_card.abilities_component
	if abilities != null and abilities.get_meta(ability_name, null) == self:
		abilities.remove_meta(ability_name)
	
	_registered_card = null
