#extends Area2D
#
#enum SIZE_TYPES {small, medium, big}
#
#@onready var collider = $CollisionShape2D
#@export var size : SIZE_TYPES
#var holding := false
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
#
#
#func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	##print("shape entrou")
	#if area is Draggable:
		#if not area.dragging:
			#print("Colocando")
			#area.global_position = global_position
