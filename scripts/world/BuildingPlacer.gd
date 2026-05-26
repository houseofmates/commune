extends Node2D
class_name BuildingPlacer

var current_building_id: String = ""
var current_cost: Dictionary = {}
var is_placing: bool = false
var preview_sprite: Sprite2D = null

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
	# Create preview sprite
	preview_sprite = Sprite2D.new()
	preview_sprite.modulate = Color(1, 1, 1, 0.5)
	preview_sprite.visible = false
	add_child(preview_sprite)

func start_placement(id: String, cost: Dictionary) -> void:
	current_building_id = id
	current_cost = cost
	is_placing = true
	preview_sprite.visible = true
	# Load building texture for preview
	var path = "res://assets/sprites/buildings/" + id + ".png"
	if FileAccess.file_exists(path):
		preview_sprite.texture = load(path)

func _input(event: InputEvent) -> void:
	if not is_placing: return

	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		var mouse_pos = get_global_mouse_position()
		var tile_pos = world_map.local_to_map(world_map.to_local(mouse_pos))
		preview_sprite.global_position = world_map.to_global(world_map.map_to_local(tile_pos))

	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			var mouse_pos = get_global_mouse_position()
			place_building(mouse_pos)

	if event.is_action_pressed("ui_cancel"):
		cancel_placement()

func place_building(world_pos: Vector2) -> void:
	if not BUILDING_SCENES.has(current_building_id):
		return

	# Final affordability check
	for res_id in current_cost.keys():
		if not GameState.has_enough_resources(res_id, current_cost[res_id]):
			cancel_placement()
			return

	# Consume resources
	for res_id in current_cost.keys():
		GameState.consume_resource(res_id, current_cost[res_id])

	var tile_pos = world_map.local_to_map(world_map.to_local(world_pos))
	var scene_path = BUILDING_SCENES[current_building_id]

	var building_scene = load(scene_path)
	if building_scene:
		var instance = building_scene.instantiate() as BaseBuilding
		instance.id = current_building_id
		instance.global_position = world_map.to_global(world_map.map_to_local(tile_pos))
		get_parent().add_child(instance)
		EventBus.building_placed.emit(instance)

	cancel_placement()

func cancel_placement() -> void:
	is_placing = false
	preview_sprite.visible = false
	current_building_id = ""
	current_cost = {}
