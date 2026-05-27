extends Node2D
class_name InteractionManager

@onready var manage_icon: Control = $ManageIcon
var current_building: Node2D = null
var interaction_radius: float = 100.0

@onready var player: Node2D = get_tree().root.find_child("Character", true, false)

func _ready() -> void:
	manage_icon.visible = false
	if not player:
		player = get_tree().get_first_node_in_group("player")
	if not player:
		# Fallback to search by type if group fails
		var roots = get_tree().get_nodes_in_group("player")
		if roots.is_empty():
			# This is a broad search, use carefully
			for node in get_tree().root.get_children():
				player = _find_character_recursive(node)
				if player: break

func _find_character_recursive(node: Node) -> Node2D:
	if node is CharacterController:
		return node
	for child in node.get_children():
		var res = _find_character_recursive(child)
		if res: return res
	return null

func _process(_delta: float) -> void:
	if not player:
		player = get_tree().root.find_child("Character", true, false)
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
