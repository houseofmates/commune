extends StaticBody3D
class_name ResourceNode

@export var resource_id: String = "wood"
@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label

func _ready() -> void:
	if not color_rect or not label:
		push_error("ResourceNode: Missing child nodes")
		return
	color_rect.color = GameState.get_resource_color(resource_id)
	label.text = resource_id.to_lower()
