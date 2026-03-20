extends Node

var selected_ability: Ability
var abilities : Array[Ability] = []
var passives : Array[Passive] = []

func _init():
	add_passive(load("res://Resources/Passives/spawn_bombs.tres"))
	add_passive(load("res://Resources/Passives/reveal_blank_at_start.tres"))
	add_passive(load("res://Resources/Passives/clear_blank_groups.tres"))
	add_ability(load("res://Resources/Abilities/basic_attack.tres"))
	add_ability(load("res://Resources/Abilities/place_flag.tres"))

func _ready():
	var grid = get_tree().get_first_node_in_group("cell_grid")
	grid.connect("cell_revealed", _on_reveal)
	grid.connect("round_start", _on_round_start)
	Global.connect("ability_selected", on_ability_selected)
	CursorPicker.connect("clicked_cell", _on_cell_clicked)

func on_ability_selected(new_ability):
	set_selected_ability(new_ability)

func set_selected_ability(new_ability: Ability):
	selected_ability = new_ability

func _on_cell_clicked(cell, event):
	if selected_ability:
		selected_ability.activate(cell, event)

func _on_reveal(revealed_cell: Cell):
	for p in passives:
		p._on_reveal(revealed_cell)

func _on_round_start(grid: CellGrid):
	for p in passives:
		p._on_round_start(grid)

func add_ability(ability: Ability):
	abilities.append(ability)

func add_passive(passive: Passive):
	passives.append(passive)
