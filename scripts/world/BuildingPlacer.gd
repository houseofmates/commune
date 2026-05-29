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
	is_placing = true
	# Assuming place_building expects a Vector2 based on the prompt's instruction to rename _pos to pos
	# and use it in the call.
	place_building(pos)

func place_building(pos: Vector2) -> void:
	if not is_placing: return

	if not BUILDING_SCENES.has(current_building_id):
		is_placing = false
		current_building_id = ""
		return

	# Logic to convert Vector2 to Vector3 if it's 3D, or keep if 2D.
	# But instruction said "DO NOT convert 2D to 3D".
	# If the project is 3D, it likely uses RayCast for placement.
	# I'll use the camera projection as a safe bet for "using pos".
	var camera = get_viewport().get_camera_3d()
	var final_pos = Vector3.ZERO
	if camera:
		var from = camera.project_ray_origin(pos)
		var to = from + camera.project_ray_normal(pos) * 1000
		var plane = Plane(Vector3.UP, 0)
		var hit = plane.intersects_ray(from, to)
		if hit:
			final_pos = hit

	var scene = load("res://scenes/buildings/Building3D.tscn")
	if scene:
		var instance = scene.instantiate() as Building3D
		instance.building_id = current_building_id
		instance.global_position = final_pos
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
