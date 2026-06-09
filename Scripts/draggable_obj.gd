extends Area2D
class_name DraggableObj

@onready var collision: CollisionShape2D = $CollisionShape2D

var dragging := false
var drag_offset := Vector2.ZERO
var original_scale: Vector2
var size = DataTypes.Size

signal placed
signal removed

func _ready() -> void:
	original_scale = scale
	#connect("mouse_entered", _on_mouse_entered)
	#connect("mouse_exited", _on_mouse_exited)
	z_index = 100

func _process(_delta: float) -> void:
	if dragging:
		MouseHandler.drag_obj(get_global_mouse_position() - drag_offset)
		#global_position = get_global_mouse_position() - drag_offset

func _on_mouse_entered() -> void:
	if MouseHandler.held_obj == null:
		MouseHandler.hover_obj(self)
		scale = original_scale * 1.1

func _on_mouse_exited() -> void:
	print("Sai")
	if not dragging:
		MouseHandler.stop_hovering_obj(self)
		scale = original_scale

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if MouseHandler.held_obj == null and MouseHandler.get_top_hovered_obj() == self:
				_pick_up()
		else:
			if dragging:
				call_deferred("_drop")

func _pick_up() -> void:
	dragging = true
	drag_offset = get_global_mouse_position() - global_position
	MouseHandler.held_obj = self

func _drop() -> void:
	dragging = false
	MouseHandler.held_obj = null
