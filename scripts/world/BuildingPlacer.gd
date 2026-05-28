extends Node3D
class_name BuildingPlacer

var current_building_id: String = ""
var current_cost: Dictionary = {}
var is_placing: bool = false
var preview_instance: Node3D = null

const BUILDING_SCENES = {
	"house": "res://scenes/buildings/Building3D.tscn",
	"farm": "res://scenes/buildings/Building3D.tscn",
	"workshop": "res://scenes/buildings/Building3D.tscn",
	"foresters_hut": "res://scenes/buildings/Building3D.tscn",
	"quarry": "res://scenes/buildings/Building3D.tscn",
	"mine": "res://scenes/buildings/Building3D.tscn",
	"sheep_farm": "res://scenes/buildings/Building3D.tscn",
	"mill": "res://scenes/buildings/Building3D.tscn",
	"sawmill": "res://scenes/buildings/Building3D.tscn",
	"stonemason": "res://scenes/buildings/Building3D.tscn",
	"smelter": "res://scenes/buildings/Building3D.tscn",
	"bakery": "res://scenes/buildings/Building3D.tscn",
	"blacksmith": "res://scenes/buildings/Building3D.tscn",
	"tailor": "res://scenes/buildings/Building3D.tscn",
	"monument": "res://scenes/buildings/Building3D.tscn"
}

func _ready() -> void:
	EventBus.build_requested.connect(start_placement)

func start_placement(id: String, cost: Dictionary) -> void:
	cancel_placement()
	current_building_id = id
	current_cost = cost
	is_placing = true

	var scene = load("res://scenes/buildings/Building3D.tscn")
	if scene:
		preview_instance = scene.instantiate() as Building3D
		preview_instance.building_id = id
		# Setup transparency for preview
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
		# We also need a 2D counterpart for game logic if that's how it works
		# But the instructions say buildings work in 3D too.
		EventBus.building_placed.emit(instance)

	cancel_placement()

func cancel_placement() -> void:
	is_placing = false
	if is_instance_valid(preview_instance):
		preview_instance.queue_free()
	preview_instance = null
	current_building_id = ""
	current_cost = {}
