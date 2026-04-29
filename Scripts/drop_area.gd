extends Area2D
class_name DropArea

var obj_ref : DraggableObj
var occupied : bool

signal object_placed
signal object_removed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("Entrando area")
	if area is DraggableObj:
		print("Entrando: ", area)
		if not occupied:
			obj_ref  = area

func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("Saindo area")
	if obj_ref and area is DraggableObj:
		print("Saindo: ", area)
		obj_ref = null

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_released("left_mouse"):
		if obj_ref:
			place_obj()
	if event.is_action_pressed("left_mouse") and occupied:
		remove_obj()

func place_obj():
	print("Placing: ", obj_ref)
	occupied = true
	obj_ref.global_position = position
	object_placed.emit()

func remove_obj():
	print("Removing: ", obj_ref)
	occupied = false
	object_removed.emit()
