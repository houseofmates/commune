extends CharacterBody2D

@export var speed: float = 200.0
@export var interaction_radius: float = 64.0

var target_position: Vector2
var is_moving: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: Node = $CharacterAnimator

func _ready() -> void:
	target_position = global_position

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag or (event is InputEventMouseButton and event.pressed):
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
	# This would normally use an Area2D, but we can do it via distance to buildings in GameState
	for b in GameState.buildings:
		if b is Node2D:
			if global_position.distance_to(b.global_position) < interaction_radius:
				EventBus.character_interacted.emit(b)
