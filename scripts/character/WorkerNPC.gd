extends CharacterBody2D
class_name WorkerNPC

@export var speed: float = 100.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var status_icon: ColorRect = $StatusIcon

var current_target: Vector2
var targets: Array = []
var target_index: int = 0

enum State { IDLE, GATHERING, TRANSPORTING, PROCESSING }
var current_state = State.IDLE

func _ready() -> void:
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
	_update_state()

func _update_state() -> void:
	# Randomly assign state for visualization
	current_state = randi() % 4 as State
	match current_state:
		State.IDLE: status_icon.color = Color.TRANSPARENT
		State.GATHERING: status_icon.color = Color.GREEN
		State.TRANSPORTING: status_icon.color = Color.YELLOW
		State.PROCESSING: status_icon.color = Color.BLUE

func _physics_process(_delta: float) -> void:
	if targets.size() == 0: return

	var direction = global_position.direction_to(current_target)
	velocity = direction * speed

	if global_position.distance_to(current_target) < 10:
		velocity = Vector2.ZERO
		animation_player.play("idle")
		await get_tree().create_timer(2.0).timeout
		_pick_next_target()
	else:
		if velocity.x != 0:
			visuals.scale.x = -1 if velocity.x < 0 else 1
		move_and_slide()
