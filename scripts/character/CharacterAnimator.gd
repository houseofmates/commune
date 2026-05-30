extends Node
class_name CharacterAnimator

@export var john_sprite_path: NodePath = "../JohnSprite"
@export var animation_player_path: NodePath = "../AnimationPlayer"

@onready var parent: Node = get_parent()
@onready var john_sprite: JohnSprite = get_node_or_null(john_sprite_path)
@onready var animation_player: AnimationPlayer = get_node_or_null(animation_player_path)

var current_state: int = -1 # Use raw int to avoid dependency cycle if possible, or just check controller

func _ready() -> void:
	if not animation_player:
		push_error("CharacterAnimator: AnimationPlayer not found!")
		return

	if not animation_player.has_animation("idle"):
		_create_animations()
	animation_player.play("idle")

func _process(_delta: float) -> void:
	if not parent or not animation_player: return

	var controller = parent as CharacterController
	if not controller: return

	if current_state != controller.current_animation_state:
		current_state = controller.current_animation_state
		match current_state:
			CharacterController.AnimationState.IDLE:
				animation_player.play("idle", 0.2)
			CharacterController.AnimationState.WALK:
				animation_player.play("walk", 0.2)

	if current_state == CharacterController.AnimationState.WALK:
		animation_player.speed_scale = controller.velocity.length() / controller.speed
	else:
		animation_player.speed_scale = 1.0

func _create_animations() -> void:
	if not john_sprite or not animation_player: return

	var library = AnimationLibrary.new()
	var sprite_path = animation_player.get_parent().get_path_to(john_sprite)

	# Idle (Breathing)
	var idle_anim = Animation.new()
	idle_anim.loop_mode = Animation.LOOP_LINEAR
	idle_anim.length = 1.0

	var frame_track = idle_anim.add_track(Animation.TYPE_METHOD)
	idle_anim.track_set_path(frame_track, sprite_path)
	idle_anim.method_track_insert_key(frame_track, 0.0, {"method": "set_frame", "args": [0]})
	idle_anim.method_track_insert_key(frame_track, 0.5, {"method": "set_frame", "args": [1]})

	var bob_track = idle_anim.add_track(Animation.TYPE_METHOD)
	idle_anim.track_set_path(bob_track, sprite_path)
	idle_anim.method_track_insert_key(bob_track, 0.0, {"method": "set_bob", "args": [0.0]})
	idle_anim.method_track_insert_key(bob_track, 0.5, {"method": "set_bob", "args": [-1.0]})

	var scale_track = idle_anim.add_track(Animation.TYPE_METHOD)
	idle_anim.track_set_path(scale_track, sprite_path)
	idle_anim.method_track_insert_key(scale_track, 0.0, {"method": "set_torso_scale", "args": [1.0]})
	idle_anim.method_track_insert_key(scale_track, 0.5, {"method": "set_torso_scale", "args": [1.02]})

	library.add_animation("idle", idle_anim)

	# Walk Cycle
	var walk_anim = Animation.new()
	walk_anim.loop_mode = Animation.LOOP_LINEAR
	walk_anim.length = 0.8

	var walk_frame_track = walk_anim.add_track(Animation.TYPE_METHOD)
	walk_anim.track_set_path(walk_frame_track, sprite_path)
	walk_anim.method_track_insert_key(walk_frame_track, 0.0, {"method": "set_frame", "args": [0]})
	walk_anim.method_track_insert_key(walk_frame_track, 0.2, {"method": "set_frame", "args": [1]})
	walk_anim.method_track_insert_key(walk_frame_track, 0.4, {"method": "set_frame", "args": [2]})
	walk_anim.method_track_insert_key(walk_frame_track, 0.6, {"method": "set_frame", "args": [3]})

	var walk_bob_track = walk_anim.add_track(Animation.TYPE_METHOD)
	walk_anim.track_set_path(walk_bob_track, sprite_path)
	walk_anim.method_track_insert_key(walk_bob_track, 0.0, {"method": "set_bob", "args": [-2.0]})
	walk_anim.method_track_insert_key(walk_bob_track, 0.2, {"method": "set_bob", "args": [0.0]})
	walk_anim.method_track_insert_key(walk_bob_track, 0.4, {"method": "set_bob", "args": [-2.0]})
	walk_anim.method_track_insert_key(walk_bob_track, 0.6, {"method": "set_bob", "args": [0.0]})

	library.add_animation("walk", walk_anim)

	animation_player.add_animation_library("", library)
