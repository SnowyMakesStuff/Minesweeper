extends Node

signal ability_selected(ability:Ability)
signal cell_hovered(cell:Cell)

const CELL_SIZE : int = 20
var base_cell_reveal_speed: float = 0.1

enum SpawnMethod {
	FLAT_AMOUNT,
	PERCENT_OF_GRID,
	CHANCE_PER_CELL
	}

enum CellTag {
	MARK_ADJACENT,
	HAZARD,
	TERRAIN,
	VACANT,
	ENEMY,
	}

const ABILITY_BUTTON = preload("res://Scenes/ability_button.tscn")
const BLOCK_1X1 = preload("res://Scenes/cell.tscn")
const CELL_TYPES_PATH = "res://Resources/Cell Types/"
var cell_type_resources: Dictionary = {}

var cell_types_by_tag: Dictionary = {} # CellTag : Array[CellType]
var cell_types_without_tag: Dictionary = {} # optional

func _ready():
	var dir := DirAccess.open(CELL_TYPES_PATH)
	if dir == null:
		push_error("Could not open directory: " + CELL_TYPES_PATH)
		return
	
	for file in dir.get_files():
		var path := CELL_TYPES_PATH + file
		print("found ", file)

		var res := load(path)
		if !(res is CellType):
			print(file, " is not CellType")
			continue

		print(file, " is CellType")
		var new_cell_type: CellType = res
		cell_type_resources[new_cell_type.id] = new_cell_type

func build_cell_tag_index():
	cell_types_by_tag.clear()
	cell_types_without_tag.clear()

	for cell: CellType in cell_type_resources.values():
		for tag in cell.tags:
			if not cell_types_by_tag.has(tag):
				cell_types_by_tag[tag] = []
			
			cell_types_by_tag[tag].append(cell)

	for tag in CellTag.values():
		var list: Array[CellType] = []

		for cell: CellType in cell_type_resources.values():
			if tag not in cell.tags:
				list.append(cell)

		cell_types_without_tag[tag] = list

func get_cell_types_with_tag(tag: CellTag) -> Array[CellType]:
	if not cell_types_by_tag.has(tag):
		return []
	
	return cell_types_by_tag[tag]

func get_cell_types_without_tag(tag: CellTag) -> Array[CellType]:
	if not cell_types_without_tag.has(tag):
		return []
	
	return cell_types_without_tag[tag]

func world_to_grid(pos: Vector2) -> Vector2i:
	return Vector2i(
		round(pos.x / CELL_SIZE),
		round(pos.y / CELL_SIZE)
	)

func grid_to_world(cell: Vector2i) -> Vector2:
	return Vector2(
		cell.x * CELL_SIZE,
		cell.y * CELL_SIZE
	)
