extends Node3D
class_name Building3D

@export var building_id: String
@onready var body: MeshInstance3D = $Body
@onready var label: Label3D = $Label3D

func _ready() -> void:
	_setup_building()

func _setup_building() -> void:
	if not building_id: return
	label.text = building_id.replace("_", " ")

	var base_mat = StandardMaterial3D.new()
	base_mat.albedo_color = Color("#F0EAD6")

	var roof_mat = StandardMaterial3D.new()
	roof_mat.albedo_color = Color("#B85C3A")

	if building_id == "farm":
		base_mat.albedo_color = Color("#D4958A")

	body.material_override = base_mat
	$Roof.material_override = roof_mat

	# Scale based on ID
	match building_id:
		"house":
			scale = Vector3(1, 1, 1)
		"farm":
			scale = Vector3(1.5, 1, 1)
		"monument":
			scale = Vector3(2, 3, 2)
			base_mat.albedo_color = Color("#ffaf00")
		_:
			scale = Vector3(0.8, 0.8, 0.8)

func interact() -> void:
	# Wire this to the existing management UI
	# The Building3D node itself won't have the logic, it's just a visual.
	# We might need a parent StaticBody3D for actual interaction.
	pass
