extends Node2D

var current_building_id: String = ""
var is_placing: bool = false

@onready var world_map: TileMapLayer = get_parent().get_node("TileMapLayer")

func _ready() -> void:
	EventBus.build_requested.connect(_on_build_requested)

func _on_build_requested(id: String, _pos: Vector2) -> void:
	current_building_id = id
	is_placing = true
	# In a real game, this would show a ghost building following the mouse
	# For now, we'll just place it at the center of the viewport
	place_building(get_viewport().get_camera_2d().global_position)

func place_building(world_pos: Vector2) -> void:
	var tile_pos = world_map.local_to_map(world_map.to_local(world_pos))

	# Handle cases where capitalization might be inconsistent
	var scene_path = "res://scenes/buildings/" + current_building_id.capitalize() + ".tscn"
	# Specially handle cases like "PowerPlant" vs "power_plant"
	if current_building_id == "power_plant": scene_path = "res://scenes/buildings/PowerPlant.tscn"
	elif current_building_id == "foresters_hut": scene_path = "res://scenes/buildings/ForestersHut.tscn"
	elif current_building_id == "sheep_farm": scene_path = "res://scenes/buildings/SheepFarm.tscn"
	elif current_building_id == "sawmill": scene_path = "res://scenes/buildings/Sawmill.tscn"
	elif current_building_id == "stonemason": scene_path = "res://scenes/buildings/Stonemason.tscn"
	elif current_building_id == "smelter": scene_path = "res://scenes/buildings/Smelter.tscn"
	elif current_building_id == "bakery": scene_path = "res://scenes/buildings/Bakery.tscn"
	elif current_building_id == "blacksmith": scene_path = "res://scenes/buildings/Blacksmith.tscn"
	elif current_building_id == "tailor": scene_path = "res://scenes/buildings/Tailor.tscn"
	elif current_building_id == "mill": scene_path = "res://scenes/buildings/Mill.tscn"
	elif current_building_id == "monument": scene_path = "res://scenes/buildings/Monument.tscn"

	if not FileAccess.file_exists(scene_path):
		# Fallback to generic if specific doesn't exist
		scene_path = "res://scenes/buildings/BaseBuilding.tscn"

	var building_scene = load(scene_path)
	if building_scene:
		var instance = building_scene.instantiate()
		instance.id = current_building_id # Ensure ID is set
		instance.global_position = world_map.to_global(world_map.map_to_local(tile_pos))
		get_parent().add_child(instance)
		EventBus.building_placed.emit(instance)

	is_placing = false
	current_building_id = ""
