class_name CellGrid
extends Node2D

signal cell_added(new_cell:Cell)
signal cell_revealed(cell:Cell)
signal round_start(grid:CellGrid)

@export var grid_dimensions: Vector2i = Vector2i(10,10)
@export var grid: Dictionary # Vector2i : Cell

@export var natural_cell_pool: Array[CellType] = []

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		print("NEW GEN")
		clear_grid()
		_generate_grid()

func _generate_grid():
	var positions = get_all_grid_positions()
	
	#spawn empty cells
	for e in range(get_all_grid_positions().size()):
		if grid.size() >= get_all_grid_positions().size():
			break
		_instantiate_cell(Global.BLOCK_1X1, positions.pop_back(), natural_cell_pool.pick_random())
	
	emit_signal("round_start", self)
	queue_redraw()

func _instantiate_cell(packed_scene: PackedScene, grid_pos: Vector2i, type: CellType):
	if grid.has(grid_pos):
		return
	
	if grid.size() >= get_all_grid_positions().size():
		return
	
	var new_cell = packed_scene.instantiate()
	add_child(new_cell)
	add_cell(grid_pos, new_cell)
	new_cell.parent_grid = self
	new_cell.set_cell_type(type)

func get_adjacent_cells(origin_cell: Cell) -> Array[Cell]:
	var found_cells: Array[Cell]
	var adjacent_directions = [
		Vector2i(-1,-1),
		Vector2i(0,-1),
		Vector2i(1,-1),
		Vector2i(-1,0),
		Vector2i(1,0),
		Vector2i(-1,1),
		Vector2i(0,1),
		Vector2i(1,1)
	]
	
	for dir in adjacent_directions:
		var adjacent_cell = origin_cell.grid_pos + dir
		if !grid.has(adjacent_cell): continue
		found_cells.append(grid[adjacent_cell])
	return found_cells

func filter_cells_by_types(source: Array[Cell], filter: Array[CellType], without_type: bool) -> Array[Cell]:
	var filtered_cells: Array[Cell]
	for cell in source:
		for type in filter:
			if without_type and cell.cell_type == type or !without_type and cell.cell_type != type:
				continue
			filtered_cells.append(cell)
	return filtered_cells

func filter_cells_by_tags(source: Array[Cell], filter: Array[Global.CellTag], without_tag: bool) -> Array[Cell]:
	var filtered_cells: Array[Cell]
	for cell in source:
		for tag in filter:
			if without_tag and tag in cell.cell_type.tags or !without_tag and !(tag in cell.cell_type.tags):
				continue
			filtered_cells.append(cell)
	return filtered_cells

func get_grid_cells() -> Array[Cell]:
	var all_cells: Array[Cell]
	for cell in grid.values():
		all_cells.append(cell)
	return all_cells

func get_next_empty_cell() -> Vector2i:
	for y in grid_dimensions.y:
		for x in grid_dimensions.x:
			var cell := Vector2i(x, y)
			if not grid.has(cell):
				return cell
	return Vector2i(-1, -1) # no space left

func get_random_cell() -> Cell:
	var random_cell = grid.values().pick_random()
	return random_cell

func get_random_grid_coordinate() -> Vector2i:
	var rand_x = randi_range(0, grid_dimensions.x - 1) #make exclusive
	var rand_y = randi_range(0, grid_dimensions.y - 1) #make exclusive
	return Vector2i(rand_x, rand_y)

#func _draw():
	#var outskirts = get_outskirts()
	#
	#for x in range(0, grid_dimensions.x):
		#for y in range(0, grid_dimensions.y):
			#var cell := Vector2i(x, y) 
			#var pos := Global.grid_to_world(cell)
			#
			#if outskirts.has(cell):
				#draw_circle(pos, Global.CELL_SIZE / 4, Color.RED)
			#else:
				#draw_circle(pos, Global.CELL_SIZE / 8, Color(1,1,1,0.5))

#func get_outskirts() -> Array[Vector2i]:
	#var _outskirts: Array[Vector2i]
	#for cell in grid:
		#var _adjacent_cells = [
			#Vector2i(cell.x - 1, cell.y),
			#Vector2i(cell.x + 1, cell.y),
			#Vector2i(cell.x, cell.y - 1),
			#Vector2i(cell.x, cell.y + 1)
		#]
		#for adjacent in _adjacent_cells:
			#if !grid.has(adjacent) and !_outskirts.has(adjacent)\
			#and adjacent.x >= 0 and adjacent.x < grid_dimensions.x\
			#and adjacent.y >= 0 and adjacent.y < grid_dimensions.y:
				#_outskirts.append(adjacent)
	#return _outskirts

func clear_grid():
	for cell in grid:
		grid[cell].queue_free()
	grid.clear()
	queue_redraw()

func add_cell(grid_position: Vector2i, cell: Cell):
	#print("adding ", cell.name, " to position ", grid_position)
	cell.global_position = Global.grid_to_world(grid_position)
	cell.grid_pos = grid_position
	grid[grid_position] = cell
	cell.snap_to_grid()
	emit_signal("cell_added", cell)
	queue_redraw()

func get_all_grid_positions() -> Array[Vector2i]:
	var cells: Array[Vector2i]
	for y in grid_dimensions.y:
		for x in grid_dimensions.x:
			cells.append(Vector2i(x,y))
	cells.shuffle()
	return cells
