extends CharacterBody3D
class_name Character3D

@export var speed: float = 5.0
var target_position: Vector3
var is_moving: bool = false

@onready var body: Node3D = $Body
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	target_position = global_position
	_build_visuals()
	animation_player.play("idle")

func _build_visuals() -> void:
	var hair_mat = StandardMaterial3D.new()
	hair_mat.albedo_color = Color("#4A2C0A")
	var skin_mat = StandardMaterial3D.new()
	skin_mat.albedo_color = Color("#F5D0B0")
	var shirt_mat = StandardMaterial3D.new()
	shirt_mat.albedo_color = Color("#F5E6B8")
	var pants_mat = StandardMaterial3D.new()
	pants_mat.albedo_color = Color("#2A4A8A")
	var eye_mat = StandardMaterial3D.new()
	eye_mat.albedo_color = Color.BLUE

	# Head
	var head = MeshInstance3D.new()
	head.name = "Head"
	head.mesh = SphereMesh.new()
	head.mesh.radius = 0.25
	head.mesh.height = 0.5
	head.material_override = hair_mat
	head.position = Vector3(0, 1.8, 0)
	body.add_child(head)

	var face = MeshInstance3D.new()
	face.name = "Face"
	face.mesh = SphereMesh.new()
	face.mesh.radius = 0.2
	face.mesh.height = 0.3
	face.material_override = skin_mat
	face.position = Vector3(0, 0, 0.1)
	head.add_child(face)

	for i in [-1, 1]:
		var eye = MeshInstance3D.new()
		eye.mesh = SphereMesh.new()
		eye.mesh.radius = 0.03
		eye.mesh.height = 0.06
		eye.material_override = eye_mat
		eye.position = Vector3(0.08 * i, 0.05, 0.15)
		face.add_child(eye)

	var stache = MeshInstance3D.new()
	stache.name = "Moustache"
	stache.mesh = BoxMesh.new()
	stache.mesh.size = Vector3(0.15, 0.05, 0.05)
	stache.material_override = hair_mat
	stache.position = Vector3(0, -0.05, 0.18)
	face.add_child(stache)

	# Torso
	var torso = MeshInstance3D.new()
	torso.name = "Torso"
	torso.mesh = BoxMesh.new()
	torso.mesh.size = Vector3(0.6, 0.8, 0.3)
	torso.material_override = shirt_mat
	torso.position = Vector3(0, 1.2, 0)
	body.add_child(torso)
	_add_v_neck(torso)

	# Arms
	var l_arm = MeshInstance3D.new()
	l_arm.name = "LeftArm"
	l_arm.mesh = CylinderMesh.new()
	l_arm.mesh.top_radius = 0.08
	l_arm.mesh.bottom_radius = 0.08
	l_arm.mesh.height = 0.6
	l_arm.material_override = shirt_mat
	l_arm.position = Vector3(-0.4, 0, 0)
	l_arm.rotation.z = deg_to_rad(15)
	torso.add_child(l_arm)

	var r_arm = MeshInstance3D.new()
	r_arm.name = "RightArm"
	r_arm.mesh = CylinderMesh.new()
	r_arm.mesh.top_radius = 0.08
	r_arm.mesh.bottom_radius = 0.08
	r_arm.mesh.height = 0.6
	r_arm.material_override = shirt_mat
	r_arm.position = Vector3(0.4, 0, 0)
	r_arm.rotation.z = deg_to_rad(-15)
	torso.add_child(r_arm)

	# Legs
	var l_leg = MeshInstance3D.new()
	l_leg.name = "LeftLeg"
	l_leg.mesh = CylinderMesh.new()
	l_leg.mesh.top_radius = 0.1
	l_leg.mesh.bottom_radius = 0.2
	l_leg.mesh.height = 0.8
	l_leg.material_override = pants_mat
	l_leg.position = Vector3(-0.2, 0.4, 0)
	body.add_child(l_leg)

	var r_leg = MeshInstance3D.new()
	r_leg.name = "RightLeg"
	r_leg.mesh = CylinderMesh.new()
	r_leg.mesh.top_radius = 0.1
	r_leg.mesh.bottom_radius = 0.2
	r_leg.mesh.height = 0.8
	r_leg.material_override = pants_mat
	r_leg.position = Vector3(0.2, 0.4, 0)
	body.add_child(r_leg)

func _add_v_neck(parent: MeshInstance3D) -> void:
	var v_mesh = MeshInstance3D.new()
	v_mesh.name = "VNeck"
	v_mesh.mesh = PrismMesh.new()
	v_mesh.mesh.size = Vector3(0.4, 0.4, 0.05)
	var v_mat = StandardMaterial3D.new()
	v_mat.albedo_color = Color("#4A2C0A")
	v_mesh.material_override = v_mat
	v_mesh.position = Vector3(0, 0.2, 0.16)
	v_mesh.rotation.x = PI
	parent.add_child(v_mesh)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		var camera = get_viewport().get_camera_3d()
		if not camera: return

		# Skip if clicking UI
		if get_viewport().gui_get_focus_owner(): return

		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000
		var plane = Plane(Vector3.UP, 0)
		var hit = plane.intersects_ray(from, to)
		if hit:
			target_position = hit
			is_moving = true

func _physics_process(delta: float) -> void:
	if is_moving:
		var dir = (target_position - global_position).normalized()
		dir.y = 0
		velocity = dir * speed

		if global_position.distance_to(target_position) < 0.2:
			velocity = Vector3.ZERO
			is_moving = false
			animation_player.play("idle", 0.2)
		else:
			animation_player.play("walk", 0.2)
			var look_target = global_position + dir
			look_at(look_target, Vector3.UP)

		move_and_slide()
