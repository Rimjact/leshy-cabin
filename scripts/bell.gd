class_name Bell
extends Node2D
## Класс звоночка для сдачи хода.


## Автомат состояния игры.
@export var game_state_machine: GameStateMachine

@export_group("Bell Variations")
## Область спрайта звоночка во время хода игрока.
@export var player_turn_sprite_region: Rect2
## Область спрайта звоночка во время хода опонента.
@export var opponent_turn_sprite_region: Rect2
## Цвет света звоночка во время хода игрока.
@export var player_turn_light_color: Color
## Цвет света звоночка во время хода опонента.
@export var opponent_turn_light_color: Color

@export_group("Bell Elements")
## Спрайт звоночка.
@export var _bell_sprite: Sprite2D
## Свет звоночка.
@export var _bell_light: PointLight2D


func _ready() -> void:
	_subscribe_on_events()


## Когда на мышке нажата левая конопка мыши по компоненту.
func on_mouse_left_button_clicked(source: ClickboxComponent) -> void:
	var source_parent = source.get_parent()
	if source_parent is not Bell:
		return

	EventBus.bell_cursor_left_button_clicked.emit()


## Когда состояние игры изменено.
func on_game_state_changed(_from_state: GameState, to_state_name: String) -> void:
	match to_state_name:
		"player_turn":
			_update_sprite_region(player_turn_sprite_region)
			_update_light_color(player_turn_light_color)
		"player_cards_attack":
			_update_sprite_region(opponent_turn_sprite_region)
			_update_light_color(opponent_turn_light_color)


## Обновляет область спрайта звоночка.
func _update_sprite_region(region: Rect2) -> void:
	_bell_sprite.region_rect = region


## Обновляет цвет света возле "глаз" звоночка.
func _update_light_color(color: Color) -> void:
	_bell_light.color = color


## Подписывает методы на события.
func _subscribe_on_events() -> void:
	EventBus.game_state_changed.connect(on_game_state_changed)
