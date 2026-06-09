extends Area2D
class_name DropArea

@export var collision : CollisionShape2D
@export var size : DataTypes.Size = 1
var placed_obj : DraggableObj
var occupied : bool


signal object_placed
signal object_removed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_released("left_mouse"):
		print("Holding: ",MouseHandler.held_obj)
		if MouseHandler.held_obj and not placed_obj and MouseHandler.held_obj.size <= size:
			place_obj(MouseHandler.held_obj)
	if event.is_action_pressed("left_mouse") and placed_obj and placed_obj == MouseHandler.get_top_hovered_obj():
		remove_obj()

func place_obj(obj : DraggableObj):
	print("Placing: ", obj)
	placed_obj = obj
	obj.global_position = position
	obj.placed.emit(1)
	object_placed.emit()

func remove_obj():
	print("Removing: ", placed_obj)
	MouseHandler.hold_obj()
	placed_obj.removed.emit(-1)
	placed_obj = null
	object_removed.emit()
