class_name CardBase
extends Node2D
## Класс карточки


@export_group("Card Properties")
## Данные карточки
@export var card_data: CardData:
	set(value):
		card_data = value
		if is_node_ready():
			_apply_card_data()
## Состояние карточки
@export var state: Global.CardState = Global.CardState.IN_DECK
## Сторона карточки
@export var side: Global.BattleSide = Global.BattleSide.PLAYER

@export_group("View")
## Подпись имени
@export var name_label: Label
## Спрайт портрета
@export var portrait_sprite: Sprite2D

@export_group("Components")
## Компонент здоровья карточки
@export var health_component: CardHealthComponent
## Компонент урона карточки
@export var damage_component: CardDamageComponent
## Компонент способностей карточки
@export var abilities_component: CardAbilitiesComponent
## Компонент обмена карточки
@export var barter_component: CardBarterComponent
## Компонент ввода карточки
@export var card_input_component: CardInputComponent


const _FACE_REGION := Rect2(0, 0, 49, 64)
const _SQUIRREL_BACK_REGION := Rect2(49, 0, 49, 64)
const _ANIMAL_BACK_REGION := Rect2(98, 0, 49, 64)
const _FACE_NODE_NAMES: Array[StringName] = [
	&"CardNameLabel",
	&"AnimalSprite",
	&"CardHealthComponent",
	&"CardDamageComponent",
	&"CardAbilitiesComponent",
	&"CardBarterComponent",
]

var _logger: GameLogger

var _played: bool = false
var _face_down: bool = false


func _ready() -> void:
	_logger = Logging.create_logger(self.name)
	_logger.add_handler(Logging.create_console_handler())
	_logger.add_handler(Logging.create_file_handler())
	_apply_card_data()


## Переносит данные ресурса на компоненты и представление карточки
func _apply_card_data() -> void:
	if card_data == null:
		return
	
	if name_label:
		name_label.text = card_data.display_name
	
	if portrait_sprite:
		if card_data.portrait:
			portrait_sprite.texture = card_data.portrait
		portrait_sprite.region_enabled = true
		portrait_sprite.region_rect = card_data.portrait_region
	
	if health_component:
		health_component.apply_health(card_data.health)
	if damage_component:
		damage_component.apply_damage(card_data.damage)
	if barter_component:
		barter_component.apply_cost(card_data.currency, card_data.cost)
	if abilities_component:
		abilities_component.apply_abilities(card_data.abilities)


## Переворачивает карточку лицевой или задней стороной
func set_face_down(face_down: bool) -> void:
	if _face_down == face_down:
		return
	
	_face_down = face_down
	
	var background := get_node_or_null("CardBackground") as Sprite2D
	if background:
		background.region_rect = _get_back_region() if face_down else _FACE_REGION
	
	for node_name: StringName in _FACE_NODE_NAMES:
		var face_node := get_node_or_null(NodePath(node_name))
		if face_node:
			face_node.visible = not face_down


## Возвращает область задней стороны на текстуре карточки
func _get_back_region() -> Rect2:
	if card_data and card_data.resource_path.get_file() == "squirrel.tres":
		return _SQUIRREL_BACK_REGION
	
	return _ANIMAL_BACK_REGION


## Когда курсор навёлся на эту карточку
func _on_card_hover_started(card: CardBase) -> void:
	if card != self:
		return
	
	_hover()


## Когда курсор ушёл с этой карточки
func _on_card_hover_stopped(card: CardBase) -> void:
	if card != self:
		return
	
	_remove_hover()


## Когда карточка выбрана
func _on_card_selected(card: CardBase) -> void:
	if card != self:
		return
	
	card.state = Global.CardState.IN_HAND_SELECTED
	_logger.info("Игрок выбрал эту карту в руке")


## Когда выбор карточки снят
func _on_card_deselected(card: CardBase) -> void:
	if card != self:
		return
	
	card.state = Global.CardState.IN_HAND_HOVERED
	_logger.info("Игрок снял выбор с этой карты в руке")


## Когда позиция карточки в руке игрока обновлена 
func _on_card_in_player_deck_position_updated(card: CardBase, index: int, cards_count: int) -> void: 
	if card != self:
		return
	
	var is_selected: bool = state == Global.CardState.IN_HAND_SELECTED
	
	state = Global.CardState.ON_MOVE
	
	var player_deck_node: Node2D = get_parent()
	var new_pos_y: float = player_deck_node.global_position.y
	var new_pos_x: float = _calc_new_pos_x(index, cards_count)
	
	var new_pos := Vector2(new_pos_x, new_pos_y)
	
	if is_selected:
		new_pos.y -= 3.0
		_change_pos_tween(new_pos, Global.CardState.IN_HAND_SELECTED)
		return
	
	_change_pos_tween(new_pos, Global.CardState.IN_HAND)


## Когда карточка была уничтожена
func _on_card_destroyed(card: CardBase) -> void:
	if card != self:
		return
	
	_logger.info("Карточка была уничтожена")
	queue_free()


## Когда игроку добавлена карточка
func _on_player_card_added(card: CardBase) -> void:
	if card != self:
		return
	
	card_input_component.enable_input()
	visible = true
	state = Global.CardState.IN_HAND
	_logger.info("Карточка добавлена игроку в руки")


## Когда карточка установлена на слот
func _on_slot_card_placed(slot: SlotBase, card: CardBase, _by_card_ability: bool) -> void:
	if card != self:
		return
	
	state = Global.CardState.ON_MOVE
	_change_pos_tween(slot.global_position, Global.CardState.IN_SLOT)
	
	_logger.info("Карточка помещена на слот " + slot.name)
	
	if abilities_component.has_spawn_ability():
		var spawn_ability := abilities_component.get_spawn_ability()
		var slot_id: int = SlotsManager.get_slot_id(slot)
		spawn_ability.on_slot_placed(self, slot_id)


## Когда твин пермещения карточки завершён
func _on_change_pos_tween_completed(target_state: Global.CardState) -> void:
	state = target_state


## Когда ход в битве перешёл карточке игрока
func _on_battle_player_card_turn(card: CardBase, slot_id: int) -> void:
	if card != self:
		return
	if _played:
		return
	
	_do_turn(slot_id)


## Когда ход в битве перешёл карточке оппонента
func _on_battle_opponent_card_turn(card: CardBase, slot_id: int) -> void:
	if card != self:
		return
	if _played:
		return
	
	_do_turn(slot_id)


## Когда карточка атакована
func _on_card_attacked(attack_info: AttackCardInfo) -> void:
	if attack_info.victime_card != self:
		return
	if not abilities_component.has_defence_ability():
		return
	
	var card_defence_ability := abilities_component.get_defence_ability()
	card_defence_ability.defence(attack_info)


## Когда карточка переместилась
func _on_card_moved(card: CardBase, _from_slot: SlotBase, to_slot: SlotBase) -> void:
	if card != self:
		return
	
	state = Global.CardState.ON_MOVE
	_change_pos_tween(to_slot.global_position, Global.CardState.IN_SLOT)


## Когда карточки игрока закончили атаковать
func _on_battle_player_cards_attack_ended() -> void:
	_played = false


## Когда карточки оппонента закончили атаковать
func _on_battle_opponent_cards_attack_ended() -> void:
	_played = false


## Карточка выполняет свой ход
func _do_turn(slot_id: int) -> void:
	var defence_ability := abilities_component.get_defence_ability()
	if defence_ability:
		defence_ability.prepare_turn(self)
	
	if abilities_component.has_pre_turn_ability():
		_logger.info("Карточка выполняет действия перед ходом")
		var card_pre_turn_ability := abilities_component.get_pre_turn_ability()
		var continue_turn: bool = card_pre_turn_ability.pre_turn(self, slot_id)
		if not continue_turn:
			return
	
	_logger.info("Карточка начала свой ход")
	
	var target_slots: Array[SlotBase]
	
	if abilities_component.has_targeting_ability():
		var card_targeting_ability := abilities_component.get_targeting_ability()
		target_slots = card_targeting_ability.get_target_slots(self, slot_id)
		_logger.info("Карточка выбрала целей: " + var_to_str(target_slots.size()))
	
	if abilities_component.has_attack_ability() and target_slots.size() > 0:
		_logger.info("Карточка атакует выбранные цели")
		var card_attack_ability := abilities_component.get_attack_ability()
		card_attack_ability.attack(self, target_slots)
	
	if abilities_component.has_movement_ability():
		_logger.info("Карточка выполняет перемещение")
		var card_movement_ability := abilities_component.get_movement_ability()
		card_movement_ability.move_from(self, slot_id)
	
	if abilities_component.has_after_turn_ability():
		_logger.info("Карточка заканчивает ход")
		var card_after_turn_ability := abilities_component.get_after_turn_ability()
		card_after_turn_ability.end_turn(self, slot_id)
	
	if defence_ability and is_instance_valid(defence_ability):
		defence_ability.finish_turn(self)
	
	_played = true


## Выделяет карточку среди прочих
func _hover() -> void:
	state = Global.CardState.IN_HAND_HOVERED
	
	z_index = 3
	
	var hover_pos: Vector2 = _calc_hover_pos(true)
	_hover_tween(hover_pos)


## Убирает выделение карточки среди прочих
func _remove_hover() -> void:
	state = Global.CardState.IN_HAND
	
	z_index = 2
	
	var remove_hover_pos: Vector2 = _calc_hover_pos(false)
	_hover_tween(remove_hover_pos)


## Расчитывает позицию для выделения карточки или для снятия выделения
func _calc_hover_pos(is_hover: bool) -> Vector2:
	var player_deck_node: Node2D = get_parent() 
	var y_center: float = player_deck_node.global_position.y
	
	var hover_x: float = global_position.x
	var hover_y: float = y_center - 3 if is_hover else y_center
	
	return Vector2(hover_x, hover_y)


## Рассчитывает позицию карточки по координате X, учитывая её индекс
func _calc_new_pos_x(index: int, cards_count: int) -> float:
	var player_deck_node: Node2D = get_parent()
	var x_center: float = player_deck_node.global_position.x
	
	if cards_count == 1:
		return x_center
	
	var total_cards_width: float = cards_count * Global.CARD_WIDTH_PIX
	if total_cards_width > Global.MAX_HAND_DECK_WIDTH_PIX:
		return _calc_new_pos_x_compressed(index, cards_count, x_center)
	
	return _calc_new_pos_x_normal(index, total_cards_width, x_center)


## Рассчитывает сжатую позицию карточки по координате X, учитывая её индекс
func _calc_new_pos_x_compressed(index: int, cards_count: int, x_center: float) -> float:
	var x_pos_step: float = Global.MAX_HAND_DECK_WIDTH_PIX / cards_count
	var x_offset: float = x_center + index * Global.MAX_HAND_DECK_WIDTH_PIX / cards_count
	var x_pos: float = x_offset - Global.MAX_HAND_DECK_WIDTH_PIX / 2.0 + (Global.CARD_WIDTH_PIX - (Global.CARD_WIDTH_PIX - x_pos_step)) / 2.0
	
	return x_pos


## Рассчитывает нормальную позицию карточки по координате X, учитывая её индекс
func _calc_new_pos_x_normal(index: int, total_cards_width: float, x_center: float) -> float:
	var x_offset: float = x_center + index * Global.CARD_WIDTH_PIX
	var x_pos: float = x_offset - total_cards_width / 2.0 + Global.CARD_WIDTH_PIX / 2.0
	
	return x_pos


## Плавно перемещает карточку для выделения
func _hover_tween(target_pos: Vector2) -> void:
	var hover_tween = get_tree().create_tween()
	hover_tween.tween_property(self, "global_position", target_pos, .2)


## Плавно перемещает карточку на новую позицию и задаёт состояние
func _change_pos_tween(target_pos: Vector2, target_state: Global.CardState) -> void:
	var change_pos_tween = get_tree().create_tween()
	change_pos_tween.tween_property(self, "global_position", target_pos, .2)
	change_pos_tween.tween_callback(_on_change_pos_tween_completed.bind(target_state))


## Подключает к сигналам Шины
func _connect_to_signals() -> void:
	EventBus.card_hover_started.connect(_on_card_hover_started)
	EventBus.card_hover_stopped.connect(_on_card_hover_stopped)
	EventBus.card_selected.connect(_on_card_selected)
	EventBus.card_deselected.connect(_on_card_deselected)
	EventBus.card_in_player_deck_position_updated.connect(_on_card_in_player_deck_position_updated)
	EventBus.card_destroyed.connect(_on_card_destroyed)
	EventBus.player_card_added.connect(_on_player_card_added)
	EventBus.slot_card_placed.connect(_on_slot_card_placed)
	EventBus.battle_player_card_turn.connect(_on_battle_player_card_turn)
	EventBus.battle_opponent_card_turn.connect(_on_battle_opponent_card_turn)
	EventBus.card_attacked.connect(_on_card_attacked)
	EventBus.card_moved.connect(_on_card_moved)
	EventBus.battle_player_cards_attack_ended.connect(_on_battle_player_cards_attack_ended)
	EventBus.battle_opponent_cards_attack_ended.connect(_on_battle_opponent_cards_attack_ended)
