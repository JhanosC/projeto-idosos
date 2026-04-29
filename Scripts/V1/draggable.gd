#extends Area2D
#class_name Draggable
#
#@export var collider : CollisionShape2D
#@export var sprite : Sprite2D
#
#var dragging := false
#var draggable := false
#var can_drop := false
#var on_shelf := false
#var drop_area_ref : Area2D
#var drag_offset = Vector2.ZERO
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#collider.shape.size = sprite.texture.get_size() * sprite.scale
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if draggable:
		#if Input.is_action_just_pressed("left_mouse"):
			#if on_shelf:
				#drop_area_ref.holding = false
				#on_shelf = false
				#GameManager.remove_point()
			#drag_offset = get_global_mouse_position() - global_position
		#if Input.is_action_pressed("left_mouse"):
			#dragging = true
			#GameManager.holding_obj = true
		#if Input.is_action_just_released("left_mouse"):
			#if can_drop:
				#on_shelf = true
				#global_position = drop_area_ref.position
				#drop_area_ref.holding = true
				#GameManager.score_point()
			#dragging = false
			#GameManager.holding_obj = false
		#if dragging:
			#position = get_global_mouse_position() - drag_offset
#
#func _on_mouse_entered() -> void:
	#if not GameManager.holding_obj and not GameManager.hovering_obj:
		#draggable = true
		#GameManager.hovering_obj = true
		#scale = Vector2(1.05,1.05)
#
#func _on_mouse_exited() -> void:
	#if not GameManager.holding_obj:
		#draggable = false
		#GameManager.hovering_obj = false
		#scale = Vector2(1.0,1.0)
#
#func _on_attach_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#if area is DropArea:
		#if not area.holding:
			#if area.size >= 1:
				#print("Posso attachiar")
				#drop_area_ref = area
				#can_drop = true
#
#func _on_attach_area_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#if area == drop_area_ref:
		#print("Sai da area")
		#can_drop = false
		#drop_area_ref = null
