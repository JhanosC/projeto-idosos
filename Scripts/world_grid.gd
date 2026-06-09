class_name GridSystem2D
extends RefCounted

# Signals
signal on_value_changed(x: int, y: int, value: Variant)

# Private fields
var _width: int
var _height: int
var _cell_size: float
var _origin: Vector3
var _grid_array: Array  # 2D array
var _coordinate_converter: CoordinateConverter

# ──────────────────────────────────────────
# Static factory methods
# ──────────────────────────────────────────

static func vertical_grid(width: int, height: int, cell_size: float, origin: Vector3, debug: bool = false) -> GridSystem2D:
	return GridSystem2D.new(width, height, cell_size, origin, VerticalConverter.new(), debug)

static func horizontal_grid(width: int, height: int, cell_size: float, origin: Vector3, debug: bool = false) -> GridSystem2D:
	return GridSystem2D.new(width, height, cell_size, origin, HorizontalConverter.new(), debug)

# ──────────────────────────────────────────
# Constructor
# ──────────────────────────────────────────

func _init(width: int, height: int, cell_size: float, origin: Vector3, coordinate_converter: CoordinateConverter = null, debug: bool = false) -> void:
	_width = width
	_height = height
	_cell_size = cell_size
	_origin = origin
	_coordinate_converter = coordinate_converter if coordinate_converter != null else VerticalConverter.new()

	# Initialize 2D array
	_grid_array = []
	for x in range(_width):
		_grid_array.append([])
		for y in range(_height):
			_grid_array[x].append(null)

	if debug:
		_draw_debug_lines()

# ──────────────────────────────────────────
# Setters
# ──────────────────────────────────────────

func set_value_from_world(world_position: Vector3, value: Variant) -> void:
	var pos: Vector2i = get_xy(world_position)
	set_value(pos.x, pos.y, value)

func set_value(x: int, y: int, value: Variant) -> void:
	if _is_valid(x, y):
		_grid_array[x][y] = value
		on_value_changed.emit(x, y, value)

# ──────────────────────────────────────────
# Getters
# ──────────────────────────────────────────

func get_value_from_world(world_position: Vector3) -> Variant:
	var pos: Vector2i = get_xy(world_position)
	return get_value(pos.x, pos.y)

func get_value(x: int, y: int) -> Variant:
	return _grid_array[x][y] if _is_valid(x, y) else null

# ──────────────────────────────────────────
# Coordinate helpers
# ──────────────────────────────────────────

func _is_valid(x: int, y: int) -> bool:
	return x >= 0 and y >= 0 and x < _width and y < _height

func get_xy(world_position: Vector3) -> Vector2i:
	return _coordinate_converter.world_to_grid(world_position, _cell_size, _origin)

func get_world_position_center(x: int, y: int) -> Vector3:
	return _coordinate_converter.grid_to_world_center(x, y, _cell_size, _origin)

func _get_world_position(x: int, y: int) -> Vector3:
	return _coordinate_converter.grid_to_world(x, y, _cell_size, _origin)

# ──────────────────────────────────────────
# Debug
# ──────────────────────────────────────────

func _draw_debug_lines() -> void:
	for x in range(_width):
		for y in range(_height):
			# Labels
			var label := Label3D.new()
			label.text = "%d,%d" % [x, y]
			label.position = get_world_position_center(x, y)
			label.basis = Basis.looking_at(_coordinate_converter.forward())
			Engine.get_main_loop().current_scene.add_child.call_deferred(label)

			# Grid lines drawn via MeshInstance3D with ImmediateMesh would go here;
			# for simplicity we use print since Godot lacks Debug.DrawLine at runtime.
			# Replace with your preferred debug drawing approach.

# ──────────────────────────────────────────
# CoordinateConverter base class
# ──────────────────────────────────────────

class CoordinateConverter:
	func grid_to_world(_x: int, _y: int, _cell_size: float, _origin: Vector3) -> Vector3:
		return Vector3.ZERO

	func grid_to_world_center(_x: int, _y: int, _cell_size: float, _origin: Vector3) -> Vector3:
		return Vector3.ZERO

	func world_to_grid(_world_position: Vector3, _cell_size: float, _origin: Vector3) -> Vector2i:
		return Vector2i.ZERO

	func forward() -> Vector3:
		return Vector3.ZERO

# ──────────────────────────────────────────
# VerticalConverter  (grid on the X-Y plane)
# ──────────────────────────────────────────

class VerticalConverter extends CoordinateConverter:
	func grid_to_world(x: int, y: int, cell_size: float, origin: Vector3) -> Vector3:
		return Vector3(x, y, 0) * cell_size + origin

	func grid_to_world_center(x: int, y: int, cell_size: float, origin: Vector3) -> Vector3:
		return Vector3(x * cell_size + cell_size * 0.5, y * cell_size + cell_size * 0.5, 0.0) + origin

	func world_to_grid(world_position: Vector3, cell_size: float, origin: Vector3) -> Vector2i:
		var x := floori((world_position.x - origin.x) / cell_size)
		var y := floori((world_position.y - origin.y) / cell_size)
		return Vector2i(x, y)

	func forward() -> Vector3:
		return Vector3.FORWARD

# ──────────────────────────────────────────
# HorizontalConverter  (grid on the X-Z plane)
# ──────────────────────────────────────────

class HorizontalConverter extends CoordinateConverter:
	func grid_to_world(x: int, y: int, cell_size: float, origin: Vector3) -> Vector3:
		return Vector3(x, 0, y) * cell_size + origin

	func grid_to_world_center(x: int, y: int, cell_size: float, origin: Vector3) -> Vector3:
		return Vector3(x * cell_size + cell_size * 0.5, 0.0, y * cell_size + cell_size * 0.5) + origin

	func world_to_grid(world_position: Vector3, cell_size: float, origin: Vector3) -> Vector2i:
		var grid_position := (world_position - origin) / cell_size
		var x := floori(grid_position.x)
		var y := floori(grid_position.z)
		return Vector2i(x, y)

	func forward() -> Vector3:
		return Vector3.DOWN
