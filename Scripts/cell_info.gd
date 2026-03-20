extends MarginContainer

@onready var label = $Label

func _ready():
	Global.connect("cell_hovered", _on_cell_hovered)
	
func _on_cell_hovered(cell: Cell):
	var label_content = ""
	if cell.is_flagged:
		label_content = "(Flagged) "
	if !cell.is_revealed:
		label_content += "???"
	elif cell.cell_type == Global.cell_type_resources["bomb"]:
		label_content += "Removes a life when"
	else:
		var hazard_amount = cell.parent_grid.filter_cells(cell.parent_grid.get_adjacent_cells(cell), Global.cell_type_resources["bomb"]).size()
		label_content += "Does nothing."
		if hazard_amount > 0:
			label_content += "\nHas %s adjacent hazard." % hazard_amount
			if hazard_amount > 1:
				label_content = label_content.insert(label_content.length() - 1, "s")
	_set_label(label_content)

func _set_label(new_text :String):
	label.text = new_text
