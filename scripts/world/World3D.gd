extends Node3D
class_name World3D

@onready var building_placer: BuildingPlacer = $BuildingPlacer

func _ready() -> void:
	# Load pending buildings from save
	for b_data in GameState.pending_building_data:
		_rehydrate_building(b_data)

	GameState.pending_building_data = []
	GameState.update_worker_stats()
	SaveManager.calculate_offline_gains()

	EventBus.building_placed.connect(_on_building_placed)
	EventBus.building_upgraded.connect(_on_building_upgraded)

func _rehydrate_building(data: Dictionary) -> void:
	var id = data["id"]
	if not BuildingPlacer.BUILDING_SCENES.has(id): return

	var scene = load(BuildingPlacer.BUILDING_SCENES[id])
	var instance = scene.instantiate()
	instance.building_id = id
	instance.global_position = Vector3(data["position"]["x"], 0, data["position"]["y"])
	add_child(instance)
	GameState.buildings.append(instance)

func _on_building_placed(building: Node):
	var p = SimpleParticles.new()
	p.global_position = building.global_position
	add_child(p)

func _on_building_upgraded(_building: Node):
	pass
