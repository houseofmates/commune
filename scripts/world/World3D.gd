extends Node3D
class_name World3D

const WORLD_SCALE_FACTOR: float = 32.0

@onready var camera_rig: Node3D = $CameraRig
@onready var player: CharacterBody3D = $Character3D

func _ready() -> void:
	EventBus.building_placed.connect(_on_building_placed)
	# Position player
	player.global_position = Vector3(0, 0, 0)

func _process(delta: float) -> void:
	if is_instance_valid(player):
		var target_pos = player.global_position
		camera_rig.global_position = camera_rig.global_position.lerp(target_pos, 0.1)

func _on_building_placed(building_node: Node) -> void:
	var b3d_scene = load("res://scenes/buildings/Building3D.tscn")
	if b3d_scene:
		var instance = b3d_scene.instantiate() as Building3D
		if building_node.get("id"):
			instance.building_id = building_node.id

		# Use standardized scale factor
		instance.global_position = Vector3(
			building_node.global_position.x / WORLD_SCALE_FACTOR,
			0,
			building_node.global_position.y / WORLD_SCALE_FACTOR
		)
		add_child(instance)
