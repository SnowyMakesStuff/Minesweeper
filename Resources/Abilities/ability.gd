class_name Ability
extends Resource


@export var id: String
@export var display_name: String
@export var texture: AtlasTexture
@export_multiline var description: String
@export_multiline var flavor_text: String

func select():
	pass

func activate(cell, event):
	pass
