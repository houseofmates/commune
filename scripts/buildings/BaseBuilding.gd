extends StaticBody2D

@export var id: String
@export var display_name: String
@export var level: int = 1
@export var max_level: int = 10

var production: Dictionary = {}
var consumption: Dictionary = {}
var upgrade_cost_multiplier: float = 1.5

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

func _ready() -> void:
	# Add to global tracking
	if not GameState.buildings.has(self):
		GameState.buildings.append(self)

	# Load specific data from JSON if available
	setup_building()
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
			break

func upgrade() -> bool:
	if level < max_level:
		var cost = get_upgrade_cost()
		# Check if we have resources
		for res_id in cost.keys():
			if not GameState.consume_resource(res_id, cost[res_id]):
				return false

		level += 1
		update_ui()
		EventBus.building_upgraded.emit(self)
		return true
	return false

func get_upgrade_cost() -> Dictionary:
	var base_cost = {} # Should come from data
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

func update_ui() -> void:
	if label:
		label.text = "%s (Lvl %d)" % [display_name, level]

func interact() -> void:
	print("Interacted with ", display_name)
	# Maybe open an upgrade menu?
