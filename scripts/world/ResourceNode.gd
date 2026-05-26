extends StaticBody2D
class_name ResourceNode

@export var resource_id: String
@export var display_name: String
@export var node_color: Color = Color.GREEN

func _ready() -> void:
	if has_node("ColorRect"):
		get_node("ColorRect").color = node_color
	if has_node("Label"):
		get_node("Label").text = display_name
