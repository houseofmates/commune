extends CharacterBody2D
class_name ComradeJohn

@export var speed: float = 150.0
@export var visuals_path: NodePath = "Visuals"
@export var animation_player_path: NodePath = "AnimationPlayer"
@export var shadow_path: NodePath = "Shadow"

var target_position: Vector2
var is_moving: bool = false

@onready var visuals: Node2D = get_node_or_null(visuals_path)
@onready var animation_player: AnimationPlayer = get_node_or_null(animation_player_path)
@onready var shadow: ColorRect = get_node_or_null(shadow_path)

func _ready() -> void:
	target_position = global_position
	if animation_player:
		animation_player.play("idle")
	else:
		push_error("ComradeJohn: AnimationPlayer not found at %s" % animation_player_path)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		target_position = get_global_mouse_position()
		is_moving = true

func _physics_process(_delta: float) -> void:
	if is_moving:
		var distance = global_position.distance_to(target_position)
		if distance < 5:
			velocity = Vector2.ZERO
			is_moving = false
			if animation_player:
				animation_player.play("idle", 0.2)
		else:
			var direction = (target_position - global_position).normalized()
			velocity = direction * speed
			if animation_player:
				animation_player.play("walk", 0.2)

			if visuals and direction.x != 0:
				visuals.scale.x = -1 if direction.x < 0 else 1

		move_and_slide()
