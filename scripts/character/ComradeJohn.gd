extends CharacterBody2D

@export var speed: float = 150.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var shadow: ColorRect = $Shadow

var target_position: Vector2
var is_moving: bool = false

func _ready() -> void:
	target_position = global_position
	animation_player.play("idle")

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag or (event is InputEventMouseButton and event.pressed):
		target_position = get_global_mouse_position()
		is_moving = true

func _physics_process(_delta: float) -> void:
	if is_moving:
		var direction = global_position.direction_to(target_position)
		velocity = direction * speed

		if global_position.distance_to(target_position) < 5:
			velocity = Vector2.ZERO
			is_moving = false
			animation_player.play("idle")
		else:
			animation_player.play("walk")
			# Flip visuals based on direction
			if velocity.x != 0:
				visuals.scale.x = -1 if velocity.x < 0 else 1

		move_and_slide()
