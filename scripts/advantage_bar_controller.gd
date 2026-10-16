class_name AdvantageBarController
extends Node2D
## Контроллер полоски преимущества


## Сердца игрока
@export var player_hearts: Array[Sprite2D]
## Сердца опонента
@export var opponent_hearts: Array[Sprite2D]

## Спрайт указателя
@export var arrow_sprite: Sprite2D

var _logger: GameLogger


func _ready() -> void:
    _logger = Logging.create_logger(self.name)
    _logger.add_handler(Logging.create_console_handler())
    _logger.add_handler(Logging.create_file_handler())

    _connect_signals()


## Обновляет видимость сердец на полоске
func _update_hearts_view(value: int) -> void:
    _show_all_hearts()
    
    if value == 0:
        _move_arrow(0.0)

    if value > 0:
        _hide_opponent_hearts(value)
        return

    if value < 0:
        _hide_player_hearts(value * -1)


## Скрывает сердца игрока
func _hide_player_hearts(count: int) -> void:
    for i in range(0, count):
        player_hearts[i].hide()
    
    var last_heart_y_pos: float = player_hearts[count - 1].position.y
    _move_arrow(last_heart_y_pos)
    _logger.info("Скрыто сердец игрока: " + var_to_str(count))


## Скрывает сердца опонента
func _hide_opponent_hearts(count: int) -> void: 
    for i in range(0, count):
        opponent_hearts[i].hide()
    
    var last_heart_y_pos: float = opponent_hearts[count - 1].position.y
    _move_arrow(last_heart_y_pos)
    _logger.info("Скрыто сердец опонента: " + var_to_str(count))


## Показывает все сердца
func _show_all_hearts() -> void:
    for heart: Sprite2D in player_hearts:
        heart.show()
    for heart: Sprite2D in opponent_hearts:
        heart.show()


## Передвигает указатель
func _move_arrow(y_pos: float) -> void:
    var move_tween = get_tree().create_tween()
    move_tween.tween_property(arrow_sprite, "position", Vector2(3.0, y_pos), .2)


## Присоединяет сигналы Шины
func _connect_signals() -> void:
    EventBus.battle_advantage_changed.connect(_update_hearts_view)