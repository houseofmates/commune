extends Node3D
class_name SimpleParticles

func _ready() -> void:
	var mesh = MeshInstance3D.new()
	mesh.mesh = BoxMesh.new()
	mesh.mesh.size = Vector3(0.1, 0.1, 0.1)

	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.YELLOW
	mesh.material_override = mat

	for i in range(10):
		var p = mesh.duplicate()
		add_child(p)
		var tween = create_tween()
		var target = Vector3(randf_range(-1, 1), randf_range(1, 2), randf_range(-1, 1))
		tween.tween_property(p, "position", target, 0.5)
		tween.parallel().tween_property(p, "scale", Vector3.ZERO, 0.5)

	await get_tree().create_timer(0.6).timeout
	queue_free()
