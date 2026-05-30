extends CharacterBody2D
class_name CharacterController

@export var speed: float = 200.0
@export var interaction_radius: float = 64.0

enum AnimationState { IDLE, WALK }
var current_animation_state: AnimationState = AnimationState.IDLE

var target_position: Vector2
var is_moving: bool = false
var last_interacted_target: Node2D = null

@onready var sprite: JohnSprite = $JohnSprite
@onready var animator: CharacterAnimator = $CharacterAnimator

func _ready() -> void:
	target_position = global_position
	current_animation_state = AnimationState.IDLE

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		target_position = get_global_mouse_position()
		is_moving = true
		current_animation_state = AnimationState.WALK

func _physics_process(_delta: float) -> void:
	if is_moving:
		var direction = global_position.direction_to(target_position)
		velocity = direction * speed

		if global_position.distance_to(target_position) < 5:
			velocity = Vector2.ZERO
			is_moving = false
			current_animation_state = AnimationState.IDLE

		move_and_slide()

		# Update sprite direction
		if velocity.x != 0:
			sprite.scale.x = abs(sprite.scale.x) * (-1 if velocity.x < 0 else 1)

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
