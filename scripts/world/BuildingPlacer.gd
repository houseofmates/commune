extends Node2D
class_name BuildingPlacer

var current_building_id: String = ""
var is_placing: bool = false

@onready var world_map: TileMapLayer = get_parent().get_node("TileMapLayer")

const BUILDING_SCENES = {
	"house": "res://scenes/buildings/House.tscn",
	"farm": "res://scenes/buildings/Farm.tscn",
	"workshop": "res://scenes/buildings/Workshop.tscn",
	"power_plant": "res://scenes/buildings/PowerPlant.tscn",
	"library": "res://scenes/buildings/Library.tscn",
	"foresters_hut": "res://scenes/buildings/ForestersHut.tscn",
	"quarry": "res://scenes/buildings/Quarry.tscn",
	"mine": "res://scenes/buildings/Mine.tscn",
	"sheep_farm": "res://scenes/buildings/SheepFarm.tscn",
	"mill": "res://scenes/buildings/Mill.tscn",
	"sawmill": "res://scenes/buildings/Sawmill.tscn",
	"stonemason": "res://scenes/buildings/Stonemason.tscn",
	"smelter": "res://scenes/buildings/Smelter.tscn",
	"bakery": "res://scenes/buildings/Bakery.tscn",
	"blacksmith": "res://scenes/buildings/Blacksmith.tscn",
	"tailor": "res://scenes/buildings/Tailor.tscn",
	"monument": "res://scenes/buildings/Monument.tscn"
}

func _ready() -> void:
	EventBus.build_requested.connect(_on_build_requested)

func _on_build_requested(id: String, pos: Vector2) -> void:
	current_building_id = id
	is_placing = true
	place_building(pos)

func place_building(world_pos: Vector2) -> void:
	if not BUILDING_SCENES.has(current_building_id):
		push_error("Building ID not found: " + current_building_id)
		return

	var tile_pos = world_map.local_to_map(world_map.to_local(world_pos))
	var scene_path = BUILDING_SCENES[current_building_id]

	var building_scene = load(scene_path)
	if building_scene:
		var instance = building_scene.instantiate()
		instance.id = current_building_id
		instance.global_position = world_map.to_global(world_map.map_to_local(tile_pos))
		get_parent().add_child(instance)
		EventBus.building_placed.emit(instance)
	else:
		push_error("Failed to load building scene: " + scene_path)

	is_placing = false
	current_building_id = ""
