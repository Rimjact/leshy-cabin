class_name CardAbilitiesComponent
extends Node2D
## Класс компонента способностей карточки


## Возвращает способность по её уникальному имени
func get_ability(ability_name: StringName) -> CardAbility:
	return get_meta(ability_name, null)


## Проверяет, имеет ли способность по её уникальному имени
func has_ability(ability_name: StringName) -> bool:
	return has_meta(ability_name)
