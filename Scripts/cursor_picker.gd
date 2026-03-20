extends Node2D

signal clicked_cell(cell:Cell, event)

var hovered_grid_pos: Vector2i
var grid: CellGrid
var target_cell: Cell

func _ready():
	grid = get_tree().get_first_node_in_group("cell_grid")
	if grid:
		grid.connect("round_start", _on_round_start)

func _on_round_start(_grid:CellGrid):
	target_cell = null

func _physics_process(_delta):
	var mouse_cell = Global.world_to_grid(get_global_mouse_position())
	
	if hovered_grid_pos != mouse_cell:
		hovered_grid_pos = mouse_cell
		if target_cell:
			target_cell.mouse_hovered = false
			target_cell.update_texture()
		if grid.grid.has(hovered_grid_pos):
			target_cell = grid.grid[hovered_grid_pos]
			target_cell.mouse_hovered = true
			target_cell.update_texture()
			Global.emit_signal("cell_hovered", target_cell)
		else:
			target_cell = null
		#print("position: ", hovered_grid_pos)

func _input(event):
	if event is InputEventMouseButton:
		if !target_cell: return
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				print("click 1")
				emit_signal("clicked_cell", target_cell, event)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				target_cell.toggle_flag()
