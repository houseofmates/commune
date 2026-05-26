extends Node2D
class_name World

@onready var tile_map: TileMapLayer = $TileMapLayer
@onready var building_placer: BuildingPlacer = $BuildingPlacer

func _ready() -> void:
	# Load pending buildings from save
	for b_data in GameState.pending_building_data:
		_rehydrate_building(b_data)

	GameState.pending_building_data = []
	GameState.update_worker_stats()
	SaveManager.calculate_offline_gains()

func _rehydrate_building(data: Dictionary) -> void:
	# Validate building ID exists
	if not data.has("id"):
		push_warning("World._rehydrate_building: Missing 'id' in building data, skipping entry")
		return

	var id = data["id"]
	if not BuildingPlacer.BUILDING_SCENES.has(id):
		push_warning("World._rehydrate_building: Unknown building id '" + str(id) + "', skipping entry")
		return

	# Validate scene can be loaded
	var scene_path = BuildingPlacer.BUILDING_SCENES[id]
	var scene = load(scene_path)
	if not scene or not (scene is PackedScene):
		push_warning("World._rehydrate_building: Failed to load scene for building id '" + str(id) + "', skipping entry")
		return

	# Validate position data
	if not data.has("position") or not (data["position"] is Dictionary):
		push_warning("World._rehydrate_building: Invalid or missing position data for building id '" + str(id) + "', skipping entry")
		return

	var pos_data = data["position"]
	if not (pos_data.has("x") and pos_data.has("y")):
		push_warning("World._rehydrate_building: Position missing x or y coordinate for building id '" + str(id) + "', skipping entry")
		return

	var pos_x = pos_data["x"]
	var pos_y = pos_data["y"]
	if not (pos_x is float or pos_x is int) or not (pos_y is float or pos_y is int):
		push_warning("World._rehydrate_building: Position coordinates are not numeric for building id '" + str(id) + "', skipping entry")
		return

	# Instantiate and configure building
	var instance = scene.instantiate()
	if not is_instance_valid(instance) or not (instance is BaseBuilding):
		push_warning("World._rehydrate_building: Failed to instantiate BaseBuilding for id '" + str(id) + "', skipping entry")
		if is_instance_valid(instance):
			instance.queue_free()
		return

	instance.id = id
	instance.level = data.get("level", 1)
	instance.assigned_workers = data.get("assigned_workers", 0)
	instance.global_position = Vector2(pos_x, pos_y)
	add_child(instance)
