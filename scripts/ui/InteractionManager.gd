extends Node2D
class_name InteractionManager

@export var player_path: NodePath
@onready var manage_icon: Control = $ManageIcon
var current_building: Node2D = null
var interaction_radius: float = 100.0

var player: Node2D = null

func _ready() -> void:
	manage_icon.visible = false
	if not player_path.is_empty():
		player = get_node_or_null(player_path)

	if not player:
		player = get_tree().get_first_node_in_group("player")

	if not player:
		push_error("InteractionManager: Player node not found!")

func _process(_delta: float) -> void:
	if not player: return

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
		manage_icon.visible = true
		manage_icon.global_position = get_viewport().get_camera_2d().unproject_position(current_building.global_position + Vector2(0, -60))
	else:
		current_building = null
		manage_icon.visible = false

func _on_manage_pressed() -> void:
	if current_building:
		current_building.interact()
