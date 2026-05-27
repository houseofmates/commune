extends Node3D
class_name BuildingPlacer

var current_building_id: String = ""
var current_cost: Dictionary = {}
var is_placing: bool = false
var preview_instance: Node3D = null

func start_placement(id: String, cost: Dictionary) -> void:
	cancel_placement()
	current_building_id = id
	current_cost = cost
	is_placing = true

	# Create preview
	var scene = load("res://scenes/buildings/Building3D.tscn")
	if scene:
		preview_instance = scene.instantiate() as Building3D
		preview_instance.building_id = id
		preview_instance.modulate = Color(1, 1, 1, 0.5) # Assuming Building3D handles this or we adjust material
		add_child(preview_instance)

func _input(event: InputEvent) -> void:
	if not is_placing: return

	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		_update_preview_pos(event.position)

	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			_update_preview_pos(event.position)
			place_building()

	if event.is_action_pressed("ui_cancel"):
		cancel_placement()

func _update_preview_pos(screen_pos: Vector2) -> void:
	var camera = get_viewport().get_camera_3d()
	if not camera or not preview_instance: return

	var from = camera.project_ray_origin(screen_pos)
	var to = from + camera.project_ray_normal(screen_pos) * 1000
	var plane = Plane(Vector3.UP, 0)
	var hit = plane.intersects_ray(from, to)
	if hit:
		# Snap to grid (assuming 4x4 units)
		var snapped_pos = Vector3(
			round(hit.x / 4.0) * 4.0,
			0,
			round(hit.z / 4.0) * 4.0
		)
		preview_instance.global_position = snapped_pos

func place_building() -> void:
	if not is_placing or not preview_instance: return

	for res_id in current_cost.keys():
		if not GameState.has_enough_resources(res_id, current_cost[res_id]):
			cancel_placement()
			return

	for res_id in current_cost.keys():
		GameState.consume_resource(res_id, current_cost[res_id])

	var scene = load("res://scenes/buildings/Building3D.tscn")
	if scene:
		var instance = scene.instantiate() as Building3D
		instance.building_id = current_building_id
		instance.global_position = preview_instance.global_position
		get_parent().add_child(instance)
		EventBus.building_placed.emit(instance)

	cancel_placement()

func cancel_placement() -> void:
	is_placing = false
	if is_instance_valid(preview_instance):
		preview_instance.queue_free()
	preview_instance = null
	current_building_id = ""
	current_cost = {}
