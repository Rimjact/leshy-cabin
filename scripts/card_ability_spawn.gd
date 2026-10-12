@abstract
class_name CardAbilitySpawn
extends CardAbility
## Абстрактный класс способности карточки спавнить другие карточки


@abstract
## Спавнит карточки на указаных слотах
func spawn_cards_from(summoner: CardBase, slot_id: int) -> void


## Регистрирует способность карточки в компонент
func _enter_tree() -> void:
	register_ability(&"CardAbilitySpawn")


## Убирает регистрацию способности карточки из компонента
func _exit_tree() -> void:
	unregister_ability(&"CardAbilitySpawn")
