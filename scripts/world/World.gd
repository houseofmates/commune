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
	var id = data["id"]
	if not BuildingPlacer.BUILDING_SCENES.has(id): return

	var scene = load(BuildingPlacer.BUILDING_SCENES[id])
	var instance = scene.instantiate() as BaseBuilding
	instance.id = id
	instance.level = data.get("level", 1)
	instance.assigned_workers = data.get("assigned_workers", 0)
	instance.global_position = Vector2(data["position"]["x"], data["position"]["y"])
	add_child(instance)
