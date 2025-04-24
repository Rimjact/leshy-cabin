class_name InputManager
extends Node2D
## Класс менеджера ввода.


func _ready() -> void:
    get_viewport().physics_object_picking = true
    get_viewport().physics_object_picking_first_only = true
    get_viewport().physics_object_picking_sort = true


## Возвращает ноду или ничего в текущей позиции курсора.
func get_node_on_mouse_pos() -> Node:
    var space_state = get_world_2d().direct_space_state

    var params := PhysicsPointQueryParameters2D.new()
    params.canvas_instance_id = get_canvas_layer_node().get_instance_id()
    params.position = get_global_mouse_position()
    params.collide_with_areas = true

    var result = space_state.intersect_point(params)
    if result.size() > 0:
        var collider: Area2D = result[0]["collider"]
        var node: Node = collider.get_parent()
        return node

    return null


## Возвращает ноду карточки в текущей позиции курсора.
func get_card_node_on_mouse_pos() -> Card:
    var node: Node = get_node_on_mouse_pos()
    if node is Card:
        return node

    return null