extends Node

static var held_obj: DraggableObj = null
static var hovered_obj: Array = []

func get_top_hovered_obj() -> DraggableObj:
	if hovered_obj.is_empty():
		return null
	return hovered_obj.get(hovered_obj.size() - 1)

func hold_obj() -> void:
	held_obj = hovered_obj.get(hovered_obj.size() - 1)
	print("Hovered: ",hovered_obj.get(0)," Held: ",held_obj)

func release_obj() -> void:
	held_obj = null

func hover_obj(obj : Node) -> void:
	print("Hovering: ", obj)
	hovered_obj.append(obj)

func stop_hovering_obj(obj : Node) -> void:
	var index = hovered_obj.find(obj)
	if index != -1:
		hovered_obj.remove_at(index)
		print("Removed at: ", index)

func drag_obj(offset : Vector2) -> void:
	held_obj.global_position = offset
