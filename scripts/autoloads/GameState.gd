extends Node

const COLOR_BG_PRIMARY = Color("#050505")
const COLOR_BG_DARK = Color("#000000")
const COLOR_ACCENT_YELLOW = Color("#f6b012")
const COLOR_ACCENT_BLUE = Color("#3c9fdd")
const COLOR_TEXT_PRIMARY = Color("#ffffff")

var resources: Dictionary = {}
var max_storage: Dictionary = {}
var production_rates: Dictionary = {}

var buildings: Array = []
var total_workers: int = 0
var assigned_workers: int = 0
var last_save_time: int = 0

func _ready() -> void:
	last_save_time = Time.get_unix_time_from_system()
	_init_resources()

func _init_resources() -> void:
	var file = FileAccess.open("res://data/resources.json", FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		for id in data.keys():
			resources[id] = 0.0
			max_storage[id] = 1000.0 if id == "labor_vouchers" else 500.0
			production_rates[id] = 1.0 if id == "labor_vouchers" else 0.0

func add_resource(id: String, amount: float) -> void:
	if not resources.has(id):
		resources[id] = 0.0
	resources[id] = min(resources[id] + amount, max_storage.get(id, INF))
	EventBus.resource_updated.emit(id, resources[id])

func consume_resource(id: String, amount: float) -> bool:
	if resources.has(id) and resources[id] >= amount:
		resources[id] -= amount
		EventBus.resource_updated.emit(id, resources[id])
		return true
	return false

func get_building_data() -> Array:
	var file = FileAccess.open("res://data/buildings.json", FileAccess.READ)
	if file:
		var json = JSON.parse_string(file.get_as_text())
		return json if json else []
	return []

func update_worker_stats() -> void:
	total_workers = 0
	assigned_workers = 0
	for b in buildings:
		if is_instance_valid(b):
			if b.id == "house":
				total_workers += b.worker_capacity
			assigned_workers += b.assigned_workers
