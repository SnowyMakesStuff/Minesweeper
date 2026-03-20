class_name BasicSearch
extends Ability

func activate(cell:Cell, event):
	print("click and activate")
	if !cell.is_revealed and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.double_click and !cell.is_flagged:
			cell.reveal()
