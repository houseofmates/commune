extends Node

@onready var parent: CharacterBody2D = get_parent()
@onready var sprite: Sprite2D = parent.get_node("Sprite2D")

func _process(_delta: float) -> void:
	if parent.velocity.length() > 0:
		# Simple bobbing animation or just state change
		pass
	else:
		# Idle state
		pass
