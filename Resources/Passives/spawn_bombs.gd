class_name SpawnBombs
extends SpawnCells

func _on_round_start(grid: CellGrid):
	spawn_cells(grid)
