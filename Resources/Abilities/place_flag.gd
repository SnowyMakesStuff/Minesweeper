class_name PlaceFlag
extends Ability

func activate(cell:Cell, event):
	if !cell.is_revealed and event.button_index == MOUSE_BUTTON_LEFT:
		cell.toggle_flag()
