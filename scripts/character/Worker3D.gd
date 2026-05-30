extends CharacterBody3D
class_name WorkerNPC

@export var speed: float = 3.0
@export var targets: Array[Vector3] = []
var target_index: int = 0
var current_target: Vector3 = Vector3.ZERO
var is_waiting: bool = false

@onready var sprite: Sprite3D = get_node_or_null("Sprite3D")

func _ready() -> void:
	if targets.is_empty():
		return
	# Fix patrol startup: assign current_target BEFORE incrementing (implied by the logic below)
	current_target = targets[target_index]

func _physics_process(_delta: float) -> void:
	if targets.is_empty() or is_waiting:
		return

	if global_position.distance_to(current_target) < 0.5:
		velocity = Vector3.ZERO
		is_waiting = true
		await get_tree().create_timer(2.0).timeout
		is_waiting = false
		target_index = (target_index + 1) % targets.size()
		current_target = targets[target_index]
	else:
		var dir = (current_target - global_position).normalized()
		velocity = dir * speed
		move_and_slide()

		if sprite:
			if dir.x > 0:
				sprite.flip_h = false
			elif dir.x < 0:
				sprite.flip_h = true
