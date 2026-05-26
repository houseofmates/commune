class_name ResourceNode
extends StaticBody2D

@export var resource_id: String
@export var display_name: String
@export var node_color: Color = Color.GREEN

func _ready() -> void:
	$ColorRect.color = node_color
	$Label.text = display_name
