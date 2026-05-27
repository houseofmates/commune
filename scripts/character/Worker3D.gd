extends CharacterBody3D
class_name Worker3D

@export var speed: float = 3.0
var target_node: Node3D = null

func _ready() -> void:
	_build_visuals()

func _build_visuals() -> void:
	var body_mesh = MeshInstance3D.new()
	body_mesh.mesh = CylinderMesh.new()
	body_mesh.mesh.top_radius = 0.1
	body_mesh.mesh.bottom_radius = 0.3
	body_mesh.mesh.height = 1.0

	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.GRAY
	body_mesh.material_override = mat
	body_mesh.position = Vector3(0, 0.5, 0)
	add_child(body_mesh)

func _physics_process(delta: float) -> void:
	if is_instance_valid(target_node):
		var dir = (target_node.global_position - global_position).normalized()
		dir.y = 0
		velocity = dir * speed
		if global_position.distance_to(target_node.global_position) > 1.0:
			move_and_slide()
