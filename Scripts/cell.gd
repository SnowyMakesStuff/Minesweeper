class_name Cell
extends Node2D

var grid_pos : Vector2i
var cell_type: CellType
var is_revealed: bool = false
var is_flagged: bool = false
var mouse_hovered: bool = false
var entity_on_me: Entity


var parent_grid: CellGrid
@onready var sprite_2d = $Sprite2D
@onready var reveal_cover = $RevealCover
@onready var hint_label = $HintLabel


func _ready():
	update_texture()
	reveal_cover.visible = false
	_set_hint_label("")

func set_cell_type(new_type: CellType):
	cell_type = new_type
	update_texture()

func reveal():
	is_revealed = true
	reveal_cover.visible = true
	reveal_cover.play("conceal")
	await reveal_cover.animation_finished
	update_texture()
	reveal_cover.play("reveal")
	await reveal_cover.animation_finished
	reveal_cover.visible = false
	
	parent_grid.emit_signal("cell_revealed", self)

func toggle_flag():
	if is_revealed: return
	is_flagged = !is_flagged
	print("flag toggled: ", is_flagged)
	update_texture()

func update_texture():
	if is_revealed:
		#if entity_on_me:
			#_set_sprite(entity_on_me.sprite, entity_on_me.sprite_color)
			#return
		
		_set_sprite(cell_type.sprite, cell_type.sprite_color)
		var adjacent_cells = parent_grid.filter_cells_by_tags(parent_grid.get_adjacent_cells(self), [Global.CellTag.HAZARD], false).size()
		if adjacent_cells > 0 and !(Global.CellTag.HAZARD in cell_type.tags):
			hint_label.visible = true
			hint_label.text = str(adjacent_cells)
		else:
			hint_label.text = ""
	elif is_flagged:
		var flag_cell = Global.cell_type_resources["flag"]
		_set_sprite(flag_cell.sprite, flag_cell.sprite_color)
	else:
		var cloud_cell = Global.cell_type_resources["clouds"]
		_set_sprite(cloud_cell.sprite, cloud_cell.sprite_color)

func _set_sprite(sprite: AtlasTexture, modulate: Color):
	sprite_2d.texture = sprite
	sprite_2d.self_modulate = modulate

func _set_hint_label(new_text: String):
	hint_label.visible = new_text.length() > 0
	hint_label.text = new_text

func snap_to_grid() -> void:
	if !parent_grid: return
	var new_cell = Global.world_to_grid(position)
	
	# prevent overlap
	if parent_grid.grid.has(new_cell) and parent_grid.grid[new_cell] != self or !parent_grid.get_outskirts().has(new_cell):
		new_cell = grid_pos
	
	if grid_pos != new_cell:
		#move from old grid position...
		parent_grid.grid.erase(grid_pos)

		#...to the new one
		grid_pos = new_cell
		parent_grid.grid[grid_pos] = self
	
	#snap
	position = Global.grid_to_world(grid_pos)
	rotation_degrees = 0
	print("world_pos: ", global_position, " | grid_pos: ", grid_pos)
