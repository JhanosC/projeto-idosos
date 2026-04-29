extends Node2D

var points_goal
var points
var victory := false
var holding_obj := false
var hovering_obj := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func score_point() -> void:
	points += 1
	print("Points: ", points)
	if points >= points_goal:
		victory = true
		print("Goal: ", points_goal, " Points: ", points)

func remove_point() -> void:
	print("Removing points. Points: ", points)
	points -= 1

func reload() -> void:
	points = 0
	victory = false
	holding_obj = false
	hovering_obj = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
