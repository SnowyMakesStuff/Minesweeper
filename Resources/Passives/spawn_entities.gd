class_name SpawnEntities
extends Passive

@export var spawn_method: Global.SpawnMethod 
@export var spawn_method_value: int = 20
@export var entity: Array[Entity]

func spawn_entities(grid: CellGrid):
	match spawn_method:
		Global.SpawnMethod.FLAT_AMOUNT:
			var cell_amount = spawn_method_value
			for cell in cell_amount:
				var rand_cell = grid.grid.keys().pick_random()
				grid.grid[rand_cell].set_entity_on_me(entity[0])
		Global.SpawnMethod.PERCENT_OF_GRID:
			var amount_by_percent := int(grid.get_all_grid_positions().size() * (spawn_method_value / 100.0))
			for cell in amount_by_percent:
				var rand_cell = grid.grid.keys().pick_random()
				grid.grid[rand_cell].set_entity_on_me(entity[0])
		Global.SpawnMethod.CHANCE_PER_CELL:
			var rng := RandomNumberGenerator.new()
			rng.randomize()
			var chance_per_cell := spawn_method_value
			for cell in grid.grid:
				var roll := rng.randi_range(1, 100)
				if roll <= chance_per_cell:
					grid.grid[cell].set_entity_on_me(entity[0])
