extends StaticBody2D

@export var id: String
@export var display_name: String
@export var level: int = 1
@export var max_level: int = 10
@export var assigned_workers: int = 0
@export var max_workers: int = 4
@export var worker_capacity: int = 0 # For houses

var production: Dictionary = {}
var consumption: Dictionary = {}
var upgrade_cost_multiplier: float = 2.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

func _ready() -> void:
	if not GameState.buildings.has(self):
		GameState.buildings.append(self)

	setup_building()
	GameState.update_worker_stats()
	update_ui()

func setup_building() -> void:
	var data = GameState.get_building_data()
	for b_data in data:
		if b_data["id"] == id:
			display_name = b_data["display_name"]
			production = b_data["produces"]
			consumption = b_data["consumes"]
			upgrade_cost_multiplier = b_data["upgrade_cost_multiplier"]
			max_level = b_data["max_level"]
			if b_data.has("worker_capacity"):
				worker_capacity = b_data["worker_capacity"]
			break

func upgrade() -> bool:
	if level < max_level:
		var cost = get_upgrade_cost()
		for res_id in cost.keys():
			if not GameState.consume_resource(res_id, cost[res_id]):
				return false

		level += 1
		# If house, increase capacity
		if id == "house":
			worker_capacity += 2

		GameState.update_worker_stats()
		update_ui()
		EventBus.building_upgraded.emit(self)
		return true
	return false

func get_upgrade_cost() -> Dictionary:
	var base_cost = {}
	var data = GameState.get_building_data()
	for b_data in data:
		if b_data["id"] == id:
			base_cost = b_data["cost"]
			break

	var current_cost = {}
	for res_id in base_cost.keys():
		current_cost[res_id] = base_cost[res_id] * pow(upgrade_cost_multiplier, level - 1)
	return current_cost

func get_production() -> Dictionary:
	var current_prod = {}
	for res_id in production.keys():
		current_prod[res_id] = production[res_id] * level
	return current_prod

func get_consumption() -> Dictionary:
	var current_cons = {}
	for res_id in consumption.keys():
		current_cons[res_id] = consumption[res_id] * level
	return current_cons

func get_efficiency() -> float:
	if id == "house" or id == "monument":
		return 1.0
	if max_workers == 0:
		return 1.0
	return float(assigned_workers) / float(max_workers)

func assign_worker(amount: int) -> bool:
	var new_total_assigned = GameState.assigned_workers - assigned_workers + amount
	if new_total_assigned <= GameState.total_workers and amount <= max_workers and amount >= 0:
		assigned_workers = amount
		GameState.update_worker_stats()
		update_ui()
		return true
	return false

func update_ui() -> void:
	if label:
		label.text = "%s (lvl %d)\nworkers: %d/%d" % [display_name, level, assigned_workers, max_workers]
		if id == "house":
			label.text = "%s (lvl %d)\ncapacity: %d" % [display_name, level, worker_capacity]

func interact() -> void:
	EventBus.building_selected.emit({"instance": self})
