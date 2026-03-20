class_name ClearBlankGroups
extends Passive

func _on_reveal(cell: Cell):
	if !(Global.CellTag.VACANT in cell.cell_type.tags): return
	
	var grid = cell.parent_grid
	if grid.filter_cells_by_tags(grid.get_adjacent_cells(cell), [Global.CellTag.VACANT], true).size() > 0: return
	
	var adjacent_cells = grid.filter_cells_by_tags(grid.get_adjacent_cells(cell), [Global.CellTag.VACANT], false)
	for c in adjacent_cells:
		if !c.is_revealed:
			c.reveal()
