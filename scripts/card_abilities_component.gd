class_name CardAbilitiesComponent
extends Node2D
## Класс компонента способностей карточки


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


## Проверяет, имеет ли карточка способность по её уникальному имени
func has_ability(ability_name: StringName) -> bool:
	return has_meta(ability_name)


## Проверяет, имеет ли карточка способность выбирать цели
func has_targeting_ability() -> bool:
	return has_ability(&"CardAbilityTargeting")


## Проверяет, имеет ли карточка способность атаковать
func has_attack_ability() -> bool:
	return has_ability(&"CardAbilityAttack")
