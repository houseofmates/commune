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

	var building_scene = load("res://scenes/buildings/" + current_building_id.capitalize() + ".tscn")
	if building_scene:
		var instance = building_scene.instantiate()
		instance.global_position = world_map.to_global(world_map.map_to_local(tile_pos))
		get_parent().add_child(instance)
		EventBus.building_placed.emit(instance)

	is_placing = false
	current_building_id = ""
