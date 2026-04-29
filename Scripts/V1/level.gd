#extends Node2D
#
#var points_goal
#@onready var label: Label = $Label
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#label.visible = false
	#points_goal = 0
	#GameManager.points = 0
	#for child in find_children("*", "", true, false):
		#if child is Draggable:
			#points_goal += 1
			#print("Adding point to goal. Now: ", points_goal)
	#print("Points goal: ", points_goal)
	#GameManager.points_goal = points_goal
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if GameManager.victory:
		#label.visible = true
#
#
#func _on_button_pressed() -> void:
	#GameManager.reload()
	#get_tree().reload_current_scene()
