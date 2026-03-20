class_name RevealBlankAtStart
extends Passive

func _on_round_start(grid: CellGrid):
	var empty_cells = grid.filter_cells_by_tags(grid.get_grid_cells(), [Global.CellTag.VACANT], false)
	print(empty_cells)
	var checked := {}
	
	while checked.size() < empty_cells.size():
		var random_blank_cell: Cell = grid.get_random_cell()
		if checked.has(random_blank_cell):
			continue
		
		checked[random_blank_cell] = true
		
		if !grid.natural_cell_pool.has(random_blank_cell.cell_type)\
		or grid.filter_cells_by_tags(grid.get_adjacent_cells(random_blank_cell), [Global.CellTag.VACANT], true).size() > 0:
			continue
		
		random_blank_cell.reveal()
		return
	print("aaaa no cells left to check, skipping")
