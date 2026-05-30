extends Node2D
class_name World

@onready var tile_map: TileMapLayer = $TileMapLayer
@onready var building_placer: BuildingPlacer = $BuildingPlacer

var worker_nodes: Array[WorkerNPC] = []

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
	EventBus.building_upgraded.connect(_on_building_upgraded)
	EventBus.workers_need_sync.connect(_assign_workers_to_buildings)

	_sync_worker_population()

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
	if building is BaseBuilding and building.id == "house":
		_sync_worker_population()

func _on_building_upgraded(building: Node):
	if building is BaseBuilding and building.id == "house":
		_sync_worker_population()

func _on_monument_completed(pos: Vector2):
	var p = SimpleParticles.new()
	p.global_position = pos
	p.scale = Vector2(3, 3)
	add_child(p)

func _sync_worker_population() -> void:
	GameState.update_worker_stats()
	var target_count = GameState.total_workers

	# Add workers
	while worker_nodes.size() < target_count:
		_spawn_worker()

	# Remove workers
	while worker_nodes.size() > target_count:
		var w = worker_nodes.pop_back()
		if is_instance_valid(w):
			w.queue_free()

	_assign_workers_to_buildings()

func _spawn_worker() -> void:
	var worker_scene = load("res://scenes/character/WorkerNPC.tscn")
	if worker_scene:
		var worker = worker_scene.instantiate() as WorkerNPC
		var houses = GameState.buildings.filter(func(b): return b.id == "house")
		if not houses.is_empty():
			worker.global_position = houses.pick_random().global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		else:
			worker.global_position = Vector2(195, 422)

		add_child(worker)
		worker_nodes.append(worker)

func _assign_workers_to_buildings() -> void:
	var pool = worker_nodes.duplicate()
	for b in GameState.buildings:
		if b is BaseBuilding and b.id != "house" and b.id != "monument":
			for i in range(b.assigned_workers):
				if pool.is_empty(): break
				var w = pool.pop_front()
				w.assign_to(b)

	# Remaining workers go to idle/house
	for w in pool:
		w.assign_to(null)
