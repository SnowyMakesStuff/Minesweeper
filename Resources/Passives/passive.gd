class_name Passive
extends Resource

signal activate

@export var id : String
@export var name : String
@export_multiline var description : String
@export_multiline var flavor_text : String

func _on_round_start(_grid: CellGrid):
	pass

func _on_reveal(_cell: Cell):
	pass
