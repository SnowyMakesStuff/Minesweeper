class_name CellType
extends Resource

@export var id: String
@export var display_name: String
@export var sprite: AtlasTexture
@export_multiline var tooltip: String
@export var sprite_color: Color = Color(1,1,1,1)
@export var tags: Array[Global.CellTag]
