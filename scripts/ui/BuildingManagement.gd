extends Control

@onready var name_label: Label = $Panel/VBoxContainer/NameLabel
@onready var desc_label: Label = $Panel/VBoxContainer/DescLabel
@onready var prod_label: Label = $Panel/VBoxContainer/ProdLabel
@onready var upgrade_btn: Button = $Panel/VBoxContainer/UpgradeButton
@onready var worker_slider: HSlider = $Panel/VBoxContainer/WorkerSlider
@onready var worker_label: Label = $Panel/VBoxContainer/WorkerLabel
@onready var demolish_btn: Button = $Panel/VBoxContainer/DemolishButton

var current_building: Node = null

func _ready() -> void:
	visible = false
	EventBus.building_selected.connect(_on_building_selected)

func _on_building_selected(data: Dictionary) -> void:
	current_building = data["instance"]
	update_ui()
	visible = true

func update_ui() -> void:
	if not current_building: return

	name_label.text = current_building.display_name + " (lvl " + str(current_building.level) + ")"
	desc_label.text = "worker capacity: " + str(current_building.worker_capacity) if current_building.id == "house" else "production/consumption based on workers"

	var prod_text = "production:\n"
	var prod = current_building.get_production()
	for res in prod:
		prod_text += res + ": " + str(prod[res]) + "/s\n"

	var cons = current_building.get_consumption()
	if cons.size() > 0:
		prod_text += "consumption:\n"
		for res in cons:
			prod_text += res + ": " + str(cons[res]) + "/s\n"

	prod_label.text = prod_text

	var cost = current_building.get_upgrade_cost()
	var cost_text = "upgrade ("
	for res in cost:
		cost_text += str(int(cost[res])) + " " + res + " "
	cost_text += ")"
	upgrade_btn.text = cost_text

	if current_building.id == "house" or current_building.id == "monument":
		worker_slider.visible = false
		worker_label.visible = false
	else:
		worker_slider.visible = true
		worker_label.visible = true
		worker_slider.max_value = current_building.max_workers
		worker_slider.value = current_building.assigned_workers
		worker_label.text = "workers: " + str(current_building.assigned_workers) + "/" + str(current_building.max_workers)

func _on_upgrade_pressed() -> void:
	if current_building.upgrade():
		update_ui()

func _on_worker_slider_changed(value: float) -> void:
	if current_building.assign_worker(int(value)):
		update_ui()
	else:
		worker_slider.value = current_building.assigned_workers

func _on_demolish_pressed() -> void:
	# Implementation for demolition
	GameState.buildings.erase(current_building)
	current_building.queue_free()
	current_building = null
	visible = false
	GameState.update_worker_stats()

func _on_close_pressed() -> void:
	visible = false
