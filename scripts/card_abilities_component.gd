class_name CardAbilitiesComponent
extends Node2D
## Класс компонента способностей карточки


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


## Возвращает способность по её уникальному имени
func get_ability(ability_name: StringName) -> CardAbility:
	return get_meta(ability_name, null)


## Проверяет, имеет ли способность по её уникальному имени
func has_ability(ability_name: StringName) -> bool:
	return has_meta(ability_name)
