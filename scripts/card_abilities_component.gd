class_name CardAbilitiesComponent
extends Node2D
## Класс компонента способностей карточки


## Уникальные способности карточки
var _unique_abilities: Array[CardAbility]


func _on_child_order_changed() -> void:
	_update_unique_abilities_from_children()
	_update_abilites_icons_position()


## Возвращает способность по её уникальному имени
func get_ability(ability_name: StringName) -> CardAbility:
	return get_meta(ability_name, null)


## Возвращает способность карточки выбирать цели
func get_targeting_ability() -> CardAbilityTargeting:
	var ability: CardAbility = get_ability(&"CardAbilityTargeting")
	if ability is CardAbilityTargeting:
		return ability
	
	return null


## Возвращает способность карточки атаковать
func get_attack_ability() -> CardAbilityAttack:
	var ability: CardAbility = get_ability(&"CardAbilityAttack")
	if ability is CardAbilityAttack:
		return ability
	
	return null


## Возвращает способность карточки защищаться
func get_defence_ability() -> CardAbilityDefence:
	var ability: CardAbility = get_ability(&"CardAbilityDefence")
	if ability is CardAbilityDefence:
		return ability
	
	return null


## Проверяет, имеет ли карточка способность по её уникальному имени
func has_ability(ability_name: StringName) -> bool:
	return has_meta(ability_name)


## Проверяет, имеет ли карточка способность выбирать цели
func has_targeting_ability() -> bool:
	return has_ability(&"CardAbilityTargeting")


## Проверяет, имеет ли карточка способность атаковать
func has_attack_ability() -> bool:
	return has_ability(&"CardAbilityAttack")


## Проверяет, имеет ли карточка способность защищаться
func has_defence_ability() -> bool:
	return has_ability(&"CardAbilityDefence")


## Обновляет массив уникальных способностей из дочерних нод
func _update_unique_abilities_from_children() -> void:
	_unique_abilities.clear()
	
	var abilities_nodes := get_children()
	for ability_node in abilities_nodes:
		if not ability_node is CardAbility:
			continue
		
		var ability: CardAbility = ability_node
		if ability.is_unique:
			_unique_abilities.append(ability)


## Обновляет позиции и размер иконок способностей на карточке
func _update_abilites_icons_position() -> void:
	if _unique_abilities.size() == 0:
		return
	
	if _unique_abilities.size() == 1:
		var ability_node: CardAbility = _unique_abilities[0]
		ability_node.position = Vector2(0.0, 0.0)
		ability_node.scale = Vector2(1.0, 1.0)
		return
	
	var first_ability_node: CardAbility = _unique_abilities[0]
	first_ability_node.position = Vector2(-6.0, -3.0)
	first_ability_node.scale = Vector2(0.75, 0.75)
	
	var second_ability_node: CardAbility = _unique_abilities[1]
	second_ability_node.position = Vector2(6.0, 3.0)
	second_ability_node.scale = Vector2(0.75, 0.75)
