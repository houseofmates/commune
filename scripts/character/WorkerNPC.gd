extends CharacterBody2D

@export var speed: float = 100.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals

var current_target: Vector2
var targets: Array = []
var target_index: int = 0

func _ready() -> void:
	# Find some points to walk between
	# For now, let's find houses and resource nodes
	var nodes = get_tree().get_nodes_in_group("worker_targets")
	for n in nodes:
		targets.append(n.global_position)

	if targets.size() > 0:
		_pick_next_target()
	else:
		animation_player.play("idle")

func _pick_next_target() -> void:
	target_index = (target_index + 1) % targets.size()
	current_target = targets[target_index]
	animation_player.play("walk")

func _physics_process(_delta: float) -> void:
	if targets.size() == 0: return

	var direction = global_position.direction_to(current_target)
	velocity = direction * speed

	if global_position.distance_to(current_target) < 10:
		velocity = Vector2.ZERO
		animation_player.play("idle")
		# Wait a bit?
		await get_tree().create_timer(2.0).timeout
		_pick_next_target()
	else:
		if velocity.x != 0:
			visuals.scale.x = -1 if velocity.x < 0 else 1
		move_and_slide()
