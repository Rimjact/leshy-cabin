class_name CardDamageComponent
extends Node2D
## Класс компонента атаки карточки


## Количество урона, который наносит карточка
@export var damage: int

@export_group("Components")
## Лэйбл счётчика
@export var counter_label: Label

@export_group("Settings")
## Настройки лэйбла счётчика
@export var default_label_settings: LabelSettings
## Настройки лэйбла счётчика при дебаффе
@export var debuff_label_settings: LabelSettings

## Урон карточки без дебаффа
var _base_damage: int = 0
## Сколько источников дебаффа сейчас действуют на карточку
var _stink_sources: int = 0


func _ready() -> void:
	_base_damage = damage
	_refresh_damage()


## Задаёт урон из данных карточки и обновляет счётчик
func apply_damage(value: int) -> void:
	_base_damage = value
	_refresh_damage()


## Добавляет источник дебаффа. Урон уменьшается на 1 один раз
func add_stink_source() -> void:
	_stink_sources += 1
	_refresh_damage()


## Убирает источник дебаффа и возвращает урон, когда источников не осталось
func remove_stink_source() -> void:
	_stink_sources = maxi(_stink_sources - 1, 0)
	_refresh_damage()


## Обновляет урон с учётом дебаффа и текст показателя
func _refresh_damage() -> void:
	damage = _base_damage - _stink_penalty()
	_update_counter(damage)

	var counter_ls: LabelSettings = debuff_label_settings if _stink_penalty() == 1 else default_label_settings
	_update_counter_lable_settings(counter_ls)


## Дебафф отнимает единицу урона, пока действует хотя бы один источник
func _stink_penalty() -> int:
	if _stink_sources > 0:
		return 1
	
	return 0


## Обновляет текст лэйбла счётчика
func _update_counter(new_value: int) -> void:
	counter_label.text = var_to_str(new_value)


## Показывает или скрывает красный текст дебаффа
func _update_counter_lable_settings(ls: LabelSettings) -> void:
	counter_label.label_settings = ls
