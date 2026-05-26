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

	EventBus.resource_gained_at.connect(_on_resource_gained_at)
	EventBus.building_placed.connect(_on_building_placed)
	EventBus.monument_completed.connect(_on_monument_completed)

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

func _on_resource_gained_at(res_id: String, amount: float, pos: Vector2):
	var text = FloatingText.new()
	text.text = "+" + str(amount)
	text.global_position = pos
	add_child(text)

func _on_building_placed(building: Node):
	var p = SimpleParticles.new()
	p.global_position = building.global_position
	add_child(p)

func _on_monument_completed(pos: Vector2):
	var p = SimpleParticles.new()
	p.global_position = pos
	p.scale = Vector2(3, 3)
	add_child(p)
