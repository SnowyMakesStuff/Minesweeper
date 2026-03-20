extends Camera2D

@export var pos_offset: Vector2 = Vector2(0,0):
	set(new_offset):
		pos_offset = new_offset
		update_camera_position()
		update_camera_zoom()
@export var base_zoom: float = 50:
	set(new_zoom):
		base_zoom = new_zoom
		update_camera_position()
		update_camera_zoom()

var grid: CellGrid

func _ready():
	grid = get_tree().get_first_node_in_group("cell_grid")
	update_camera_position()
	update_camera_zoom()

func update_camera_zoom():
	if grid:
		var biggest_axis: float = max(grid.grid_dimensions.x, grid.grid_dimensions.y)
		var z := base_zoom / biggest_axis
		zoom = Vector2(z, z)

func update_camera_position():
	if grid:
		global_position = (Vector2(grid.grid_dimensions.x - 1, grid.grid_dimensions.y - 1) + pos_offset) * Global.CELL_SIZE / 2.0
		print(Vector2(grid.grid_dimensions) * Global.CELL_SIZE / 2.0)
