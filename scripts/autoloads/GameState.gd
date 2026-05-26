extends Node

var resources: Dictionary = {
	"food": 0.0,
	"energy": 0.0,
	"materials": 0.0,
	"knowledge": 0.0,
	"labor_points": 0.0
}

var max_storage: Dictionary = {
	"food": 100.0,
	"energy": 100.0,
	"materials": 100.0,
	"knowledge": 100.0,
	"labor_points": 1000.0
}

var production_rates: Dictionary = {
	"food": 0.0,
	"energy": 0.0,
	"materials": 0.0,
	"knowledge": 0.0,
	"labor_points": 1.0 # Base labor generation
}

var buildings: Array = [] # List of active building instances data
var last_save_time: int = 0

func _ready() -> void:
	last_save_time = Time.get_unix_time_from_system()

func add_resource(id: String, amount: float) -> void:
	if resources.has(id):
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
