extends TextureButton

var ability_resource: Ability
@onready var texture_rect = $TextureRect

func _ready():
	if ability_resource:
		_apply_ability_resource()

func set_ability_resource(new_ability_resource: Ability):
	ability_resource = new_ability_resource
	if is_node_ready():
		_apply_ability_resource()

func _apply_ability_resource():
	texture_rect.texture = ability_resource.texture

func _on_button_down():
	Global.emit_signal("ability_selected", ability_resource)
