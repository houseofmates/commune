extends CharacterBody2D
class_name CharacterController

@export var speed: float = 200.0
@export var interaction_radius: float = 64.0

var target_position: Vector2
var is_moving: bool = false
var last_interacted_target: Node2D = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: Node = $CharacterAnimator

func _ready() -> void:
	target_position = global_position

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		target_position = get_global_mouse_position()
		is_moving = true

func _physics_process(_delta: float) -> void:
	if is_moving:
		var direction = global_position.direction_to(target_position)
		velocity = direction * speed

		if global_position.distance_to(target_position) < 10:
			velocity = Vector2.ZERO
			is_moving = false

		move_and_slide()

		# Update sprite direction
		if velocity.x != 0:
			sprite.flip_h = velocity.x < 0

	# Check for building interactions
	check_interactions()

func check_interactions() -> void:
	var closest_b: Node2D = null
	var min_dist = interaction_radius

	for b in GameState.buildings:
		if is_instance_valid(b) and b is Node2D:
			var dist = global_position.distance_to(b.global_position)
			if dist < min_dist:
				min_dist = dist
				closest_b = b

	if closest_b != last_interacted_target:
		last_interacted_target = closest_b
		if closest_b:
			EventBus.character_interacted.emit(closest_b)
