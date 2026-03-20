class_name Entity
extends Resource

@export var id: String
@export var display_name: String
@export var sprite: AtlasTexture
@export var sprite_color: Color = Color(1,1,1,1)
@export var description: String
@export var flavor_text: String
@export var max_health_value: int
@export var damage_range: Vector2 = Vector2(8, 10)

func try_attack(target):
	if !target: return
	if target == Player:
		attack_player()
	elif target == Entity:
		attack_entity()

func attack_player():
	pass

func attack_entity():
	pass
