extends Node2D

@onready var ability_container = $"../Control/MarginContainer/HBoxContainer"

func _ready():
	if !ability_container: return
	for ability in Player.abilities:
		var new_ability_button = Global.ABILITY_BUTTON.instantiate()
		ability_container.add_child(new_ability_button)
		new_ability_button.set_ability_resource(ability)
