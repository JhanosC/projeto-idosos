extends Area2D
class_name DraggableObj

var dragging := false
var draggable := false
var on_shelf := false
var drag_offset = Vector2.ZERO

var original_scale : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_scale = scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("left_mouse"):
			drag_offset = get_global_mouse_position() - global_position
		if Input.is_action_pressed("left_mouse"):
			dragging = true
		if Input.is_action_just_released("left_mouse"):
			dragging = false
		if dragging:
			position = get_global_mouse_position() - drag_offset

func _on_mouse_entered() -> void:
	draggable = true
	scale = original_scale * 1.1

func _on_mouse_exited() -> void:
	if not dragging:
		draggable = false
		scale = original_scale
