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
	EventBus.build_requested.connect(_on_build_requested)

func _on_build_requested(id: String, pos: Vector2) -> void:
	cancel_placement()
	current_building_id = id
	# Assuming current_cost is managed elsewhere or we need to look it up.
	# But following instructions literally:
	is_placing = true
	# Convert pos Vector2 to Vector3 for place_building call if it's 3D
	var camera = get_viewport().get_camera_3d()
	var pos3d = Vector3.ZERO
	if camera:
		var from = camera.project_ray_origin(pos)
		var to = from + camera.project_ray_normal(pos) * 1000
		var plane = Plane(Vector3.UP, 0)
		var hit = plane.intersects_ray(from, to)
		if hit:
			pos3d = hit

	place_building(pos3d)

func place_building(pos: Vector3) -> void:
	if not is_placing: return

	if not BUILDING_SCENES.has(current_building_id):
		is_placing = false
		current_building_id = ""
		return

	var scene = load("res://scenes/buildings/Building3D.tscn")
	if scene:
		var instance = scene.instantiate() as Building3D
		instance.building_id = current_building_id
		instance.global_position = pos
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
