class_name BarterController
extends Node2D
## Класс контроллера обмена карточек


## Количество косточек у игрока
@export var bones: int = 0
## Количество принесённых в жертв карточек
@export var sacriface_count: int = 0

@export_group("Components")
## Спрайты счётчика жертв
@export var _victims_counter_sprites: Array[Sprite2D]
## Лэйбл счётчика косточек
@export var _bones_counter_lable: Label
## Лэйбл превью вычета косточек
@export var _bones_substruct_lable: Label

var _card_barter: CardBase = null

var _logger: GameLogger


func _ready() -> void:
	_logger = Logging.create_logger(self.name)
	_logger.add_handler(Logging.create_console_handler())
	_logger.add_handler(Logging.create_file_handler())
	
	_connect_signals()
	_update_bones_counter_text()


## Когда карточка выбрана
func _on_card_selected(card: CardBase) -> void:
	_card_barter = card
	
	if _is_card_currency_victims(_card_barter) and _is_can_enter_to_sacriface_mode(_card_barter):
		_enter_to_sacriface_mode(_card_barter)
		return
	
	if _is_card_currency_bones(_card_barter) and _is_can_barter_for_bones(_card_barter):
		_show_bones_substruct_text(_card_barter.barter_component.cost)
		EventBus.barter_card_bones_prepare.emit(_card_barter)
		return
	
	if _is_card_currency_free(_card_barter):
		EventBus.barter_card_free_prepare.emit(_card_barter)
		return
	
	EventBus.card_deselected.emit(_card_barter)


## Когда снят выбор с карточки
func _on_card_deselected(card: CardBase) -> void:
	if _is_card_currency_victims(card):
		_exit_from_sacriface_mode()
		return
	
	if _is_card_currency_bones(card):
		_hide_bones_substruct_text()


## Когда карточка установлена на слот
func _on_slot_card_placed(_slot: SlotBase, card: CardBase) -> void:
	if card.barter_component.currency == Global.BarterCurrency.BONES:
		bones -= card.barter_component.cost
		_update_bones_counter_text()
		_hide_bones_substruct_text()
	
	EventBus.barter_card_completed.emit(card)


## Когда игрок вошел в режим жертваприношения
func _on_barter_sacriface_mode_entered(card: CardBase) -> void:
	_show_victims_cost_counter(card.barter_component.cost)


## Когда игрок вышел из режима жертваприношения
func _on_barter_sacriface_mode_exited() -> void:
	_hide_victims_cost_counter()


## Когда карточка принесена в жертву
func _on_barter_card_sacrifaced(_card: CardBase) -> void:
	var card_cost: int = _card_barter.barter_component.cost
	sacriface_count += 1
	bones += 2
	_update_bones_counter_text()
	
	_logger.info("Количество жертв: " + var_to_str(sacriface_count) + ", стоимость: " + var_to_str(card_cost))
	if sacriface_count == card_cost:
		EventBus.barter_card_victims_completed.emit(_card_barter)
		return
	
	_hide_victims_cost_counter()
	_show_victims_cost_counter(card_cost - sacriface_count)


## Когда обмен карточки завершён за жертвы
func _on_barter_card_victims_completed(_card: CardBase) -> void:
	_logger.info("Игрок завершил обмен карточки за жертвы")
	sacriface_count = 0
	_hide_victims_cost_counter()


## Вернёт true, если валюта обмена у карточки равна жертвам
func _is_card_currency_victims(card: CardBase) -> bool:
	return card.barter_component.currency == Global.BarterCurrency.VICTIMS


## Вернёт true, если валюта обмена у карточки равна косточкам 
func _is_card_currency_bones(card: CardBase) -> bool:
	return card.barter_component.currency == Global.BarterCurrency.BONES


## Вернёт true, если карточка бесплатна для обмена 
func _is_card_currency_free(card: CardBase) -> bool:
	return card.barter_component.currency == Global.BarterCurrency.FREE


## Вернёт true, если игрок может обменять карточку за кости сейчас
func _is_can_barter_for_bones(card: CardBase) -> bool:
	var card_cost: int = card.barter_component.cost
	if bones < card_cost:
		return false
	
	return true


## Вернёт true, если игок может войти в режим жертваприношения
func _is_can_enter_to_sacriface_mode(card: CardBase) -> bool:
	var card_cost: int = card.barter_component.cost
	var cards_on_table_count: int = SlotsManager.get_player_side_slots_with_card_count()
	if cards_on_table_count < card_cost:
		return false
	
	return true


## Показывает указанное количество спрайтов счётчика жертв
func _show_victims_cost_counter(count: int) -> void:
	for i in range(0, count):
		_victims_counter_sprites[i].show()


## Скрывает все спрайты счётчика жертв
func _hide_victims_cost_counter() -> void:
	for sprite: Sprite2D in _victims_counter_sprites:
		sprite.hide()


## Обновляет текст счётчика косточек у игрока
func _update_bones_counter_text() -> void:
	_bones_counter_lable.text = var_to_str(bones)


## Показывает текст вычета косточек у игрока
func _show_bones_substruct_text(value: int) -> void:
	_bones_substruct_lable.text = "-" + var_to_str(value)
	_bones_substruct_lable.show()


## Скрывает текст вычета косточек у игрока
func _hide_bones_substruct_text() -> void:
	_bones_substruct_lable.text = ""
	_bones_substruct_lable.hide()


## Входит в режим жертваприношения
func _enter_to_sacriface_mode(card: CardBase) -> void:
	_logger.info("Игрок вошел в режим жертваприношения")
	EventBus.barter_sacriface_mode_entered.emit(card) 


## Выходит из режима жертваприношения
func _exit_from_sacriface_mode() -> void:
	_logger.info("Игрок вышел из режима жертваприношения")
	EventBus.barter_sacriface_mode_exited.emit()


## Соединяет сигналы Шины
func _connect_signals() -> void:
	EventBus.card_selected.connect(_on_card_selected)
	EventBus.card_deselected.connect(_on_card_deselected)
	EventBus.slot_card_placed.connect(_on_slot_card_placed)
	EventBus.barter_sacriface_mode_entered.connect(_on_barter_sacriface_mode_entered)
	EventBus.barter_sacriface_mode_exited.connect(_on_barter_sacriface_mode_exited)
	EventBus.barter_card_sacrifaced.connect(_on_barter_card_sacrifaced)
	EventBus.barter_card_victims_completed.connect(_on_barter_card_victims_completed)
