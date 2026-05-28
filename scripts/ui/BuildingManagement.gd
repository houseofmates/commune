extends Control
class_name BuildingManagement

@onready var name_label: Label = $Panel/VBoxContainer/NameLabel
@onready var desc_label: Label = $Panel/VBoxContainer/DescLabel
@onready var prod_label: Label = $Panel/VBoxContainer/ProdLabel
@onready var upgrade_btn: Button = $Panel/VBoxContainer/UpgradeButton
@onready var worker_container: HBoxContainer = $Panel/VBoxContainer/WorkerContainer
@onready var worker_label: Label = $Panel/VBoxContainer/WorkerLabel
@onready var demolish_btn: Button = $Panel/VBoxContainer/DemolishButton

var current_building: BaseBuilding = null

func _ready() -> void:
	visible = false
	EventBus.building_selected.connect(_on_building_selected)

func _on_building_selected(data: Dictionary) -> void:
	current_building = data["instance"]
	update_ui()
	visible = true

func update_ui() -> void:
	if not current_building: return

	name_label.text = (current_building.display_name + " (lvl " + str(current_building.level) + ")").to_lower()
	desc_label.text = ("worker capacity: " + str(current_building.worker_capacity) if current_building.id == "house" else "production/consumption based on workers").to_lower()

	var prod_text = "production:\n".to_lower()
	var prod = current_building.get_production()
	for res in prod:
		prod_text += (res + ": " + str(prod[res]) + "/s\n").to_lower()

	var cons = current_building.get_consumption()
	if cons.size() > 0:
		prod_text += "consumption:\n".to_lower()
		for res in cons:
			prod_text += (res + ": " + str(cons[res]) + "/s\n").to_lower()

	prod_label.text = prod_text

	var cost = current_building.get_upgrade_cost()
	var cost_text = "upgrade (".to_lower()
	for res in cost:
		cost_text += str(int(cost[res])) + " " + res.to_lower() + " "
	cost_text += ")"
	upgrade_btn.text = cost_text

	if current_building.id == "house" or current_building.id == "monument":
		worker_container.visible = false
		worker_label.visible = false
	else:
		worker_container.visible = true
		worker_label.visible = true
		worker_label.text = ("workers: " + str(current_building.assigned_workers) + "/" + str(current_building.max_workers)).to_lower()
		_update_worker_slots()

func _update_worker_slots() -> void:
	for child in worker_container.get_children():
		child.queue_free()

	for i in range(current_building.max_workers):
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(40, 40)
		btn.toggle_mode = true
		btn.button_pressed = i < current_building.assigned_workers
		btn.text = "w" if btn.button_pressed else "o"
		btn.pressed.connect(_on_worker_slot_pressed.bind(i))
		worker_container.add_child(btn)

func _on_worker_slot_pressed(_index: int) -> void:
	var active = 0
	for child in worker_container.get_children():
		if (child as Button).button_pressed:
			active += 1

	if not current_building.assign_worker(active):
		_update_worker_slots() # Revert
	else:
		update_ui()
		EventBus.workers_need_sync.emit()

func _on_upgrade_pressed() -> void:
	if current_building.upgrade():
		update_ui()
		EventBus.workers_need_sync.emit()

func _on_demolish_pressed() -> void:
	GameState.buildings.erase(current_building)
	current_building.queue_free()
	current_building = null
	visible = false
	GameState.update_worker_stats()

func _on_close_pressed() -> void:
	visible = false
