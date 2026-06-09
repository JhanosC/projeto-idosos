extends Node2D
class_name Level

@onready var button: Button = $Button
var bottles = preload("res://Scenes/draggable_obj.tscn")
var areas = preload("res://Scenes/drop_area.tscn")

@export var shelf : Texture2D
@export var scene_to_load: String
@export var grid_width: int = 8
@export var grid_height: int = 4
@export var cell_size: float = 100.0
@export var grid_origin: Vector2 = Vector2(360, 160)

var score_max: int = 0
var score: int = 0
var grid_system: GridSystem2D

var bottle_area_origin: Vector2
var bottle_columns: int

signal won_game

func _ready() -> void:
	button.visible = false

	var sample: DropArea = areas.instantiate()
	var collision: CollisionShape2D = sample.collision
	cell_size = collision.shape.size.x * sample.scale.x

	var origin_3d := Vector3(grid_origin.x, grid_origin.y, 0.0)
	grid_system = GridSystem2D.vertical_grid(grid_width, grid_height, cell_size, origin_3d)

	var viewport_height: float = get_viewport_rect().size.y
	var available_height: float = viewport_height

	var bottle_rows: int = max(1, int(available_height / cell_size))
	var total_bottle_height: float = bottle_rows * cell_size
	var bottle_start_y: float = available_height - 150

	bottle_columns = grid_width
	bottle_area_origin = Vector2(grid_origin.x, bottle_start_y)

	var bottle_index = 0
	var size : int = 1
	var big_areas = randi() % grid_height
	var y : int = 0
	print("Big areas: ", big_areas)
	while y < grid_height:
		print("Y: ", y)
		create_shelf(576.0, y)
		for x in range(grid_width):
			create_area(x, y, size)
			if randf_range(0.0, 10.0) < 2.0:
				create_bottle(bottle_index)
				bottle_index += 1
		if big_areas > 0:
			y = y + 2
			big_areas -= 1
		else:
			y = y + 1
			size = 0

func _on_button_pressed() -> void:
	get_tree().root.get_child(1).load_new_scene(scene_to_load)

func create_shelf(x : int, y : int) -> void:
	var shelf_sprite : Sprite2D = Sprite2D.new()
	add_child(shelf_sprite)
	shelf_sprite.texture = shelf
	shelf_sprite.scale = Vector2(0.5,0.5)
	var world_pos: Vector3 = grid_system.get_world_position_center(0, y+1)
	shelf_sprite.global_position = Vector2(x,world_pos.y)

func create_area(x: int, y: int, size : int) -> void:
	var area_instance: DropArea = areas.instantiate()
	add_child(area_instance)
	var world_pos: Vector3 = grid_system.get_world_position_center(x, y)
	area_instance.global_position = Vector2(world_pos.x, world_pos.y)
	area_instance.size = size
	if size >= 1:
		area_instance.scale.y *= 2.0
	grid_system.set_value(x, y, area_instance)

func create_bottle(index: int) -> void:
	var bottle_instance: DraggableObj = bottles.instantiate()
	add_child(bottle_instance)

	var col: int = index % bottle_columns
	var row: int = index / bottle_columns
	bottle_instance.global_position = Vector2(
		bottle_area_origin.x + col * cell_size + cell_size * 0.1,
		bottle_area_origin.y + row * cell_size + cell_size * 0.1
	)
	bottle_instance.size = 1
	score_max += 1
	bottle_instance.connect("placed", change_score)
	bottle_instance.connect("removed", change_score)

func get_area_at_world_pos(world_pos: Vector2) -> DropArea:
	var value = grid_system.get_value_from_world(Vector3(world_pos.x, world_pos.y, 0.0))
	return value as DropArea

func win() -> void:
	button.visible = true
	won_game.emit()

func change_score(amount: int = 1) -> void:
	score += amount
	if score >= score_max:
		win()
