@abstract
class_name CardAbility
extends Node2D
## Абстрактный класс способности карточки


func _enter_tree() -> void:
	assert(owner is CardAbilitiesComponent)
