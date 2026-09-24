@abstract
class_name CardAbilitySpawn
extends CardAbility
## Абстрактный класс способности карточки спавнить другие карточки


@abstract
## Спавнит карточки на указаных слотах
func spawn_cards_at(summoner: CardBase, slots: Array[SlotBase]) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	assert(owner is CardBase)
	
	if owner is CardBase:
		var card: CardBase = owner
		card.abilities_component.set_meta(&"CardAbilitySpawn", self)


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	if owner is CardBase:
		var card: CardBase = owner
		card.remove_meta(&"CardAbilitySpawn")
