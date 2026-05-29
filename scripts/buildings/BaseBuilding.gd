extends StaticBody2D
class_name BaseBuilding

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
	update_label()

## Configures the building based on JSON data
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

## Upgrades the building level if affordable
func upgrade() -> bool:
	if level >= max_level:
		return false

	var cost = get_upgrade_cost()
	# Phase 1: check all resources available without spending
	for res_id in cost.keys():
		if GameState.resources.get(res_id, 0) < cost[res_id]:
			return false
	# Phase 2: spend all resources
	for res_id in cost.keys():
		GameState.consume_resource(res_id, cost[res_id])
	level += 1
	update_label()
	return true

## Calculates the cost for the next upgrade
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

## Returns current production values (level * efficiency applied)
func get_production() -> Dictionary:
	var efficiency = get_efficiency()
	var current_prod = {}
	for res_id in production.keys():
		current_prod[res_id] = production[res_id] * level * efficiency
	return current_prod

## Returns current consumption values (level * efficiency applied)
func get_consumption() -> Dictionary:
	var efficiency = get_efficiency()
	var current_cons = {}
	for res_id in consumption.keys():
		current_cons[res_id] = consumption[res_id] * level * efficiency
	return current_cons

## Calculates worker efficiency
func get_efficiency() -> float:
	if id == "house" or id == "monument" or max_workers == 0:
		return 1.0
	return float(assigned_workers) / float(max_workers)

## Assigns workers to the building
func assign_worker(amount: int) -> bool:
	var new_total_assigned = GameState.assigned_workers - assigned_workers + amount
	if new_total_assigned <= GameState.total_workers and amount <= max_workers and amount >= 0:
		assigned_workers = amount
		GameState.update_worker_stats()
		update_label()
		return true
	return false

## Updates the building's world-space UI
func update_label() -> void:
	if label:
		label.text = "%s (lvl %d)\nworkers: %d/%d" % [display_name, level, assigned_workers, max_workers]
		if id == "house":
			label.text = "%s (lvl %d)\ncapacity: %d" % [display_name, level, worker_capacity]

## Called when the character interacts with the building
func interact() -> void:
	EventBus.building_selected.emit({"instance": self})
