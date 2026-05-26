extends Node2D

@onready var manage_icon: Control = $ManageIcon
var current_building: Node2D = null
var interaction_radius: float = 100.0

@onready var player: Node2D = get_tree().root.find_child("ComradeJohn", true, false)

func _ready() -> void:
	manage_icon.visible = false

func _process(_delta: float) -> void:
	if not player:
		player = get_tree().root.find_child("ComradeJohn", true, false)
		return

	var closest_b = null
	var min_dist = interaction_radius

	for b in GameState.buildings:
		if is_instance_valid(b) and b is Node2D:
			var dist = player.global_position.distance_to(b.global_position)
			if dist < min_dist:
				min_dist = dist
				closest_b = b

	if closest_b:
		current_building = closest_b
		var camera = get_viewport().get_camera_2d()
		if camera != null:
			manage_icon.visible = true
			manage_icon.global_position = camera.unproject_position(current_building.global_position + Vector2(0, -60))
		else:
			manage_icon.visible = false
	else:
		current_building = null
		manage_icon.visible = false

func _on_manage_pressed() -> void:
	if is_instance_valid(current_building) and current_building.has_method("interact"):
		current_building.interact()
