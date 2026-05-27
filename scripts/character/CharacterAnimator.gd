extends Node
class_name CharacterAnimator

@onready var parent: CharacterController = get_parent()
@onready var john_sprite: JohnSprite = parent.get_node("JohnSprite")
@onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")

var current_state: CharacterController.AnimationState = CharacterController.AnimationState.IDLE

func _ready() -> void:
	if not animation_player.has_animation("idle"):
		_create_animations()
	animation_player.play("idle")

func _process(_delta: float) -> void:
	if current_state != parent.current_animation_state:
		current_state = parent.current_animation_state
		match current_state:
			CharacterController.AnimationState.IDLE:
				animation_player.play("idle", 0.2)
			CharacterController.AnimationState.WALK:
				animation_player.play("walk", 0.2)

	if current_state == CharacterController.AnimationState.WALK:
		animation_player.speed_scale = parent.velocity.length() / parent.speed
	else:
		animation_player.speed_scale = 1.0

func _create_animations() -> void:
	var library = AnimationLibrary.new()

	# Idle (Breathing)
	var idle_anim = Animation.new()
	idle_anim.loop_mode = Animation.LOOP_LINEAR
	idle_anim.length = 1.0

	var frame_track = idle_anim.add_track(Animation.TYPE_METHOD)
	idle_anim.track_set_path(frame_track, "JohnSprite")
	idle_anim.method_track_insert_key(frame_track, 0.0, {"method": "set_frame", "args": [0]})
	idle_anim.method_track_insert_key(frame_track, 0.5, {"method": "set_frame", "args": [1]})

	var bob_track = idle_anim.add_track(Animation.TYPE_METHOD)
	idle_anim.track_set_path(bob_track, "JohnSprite")
	idle_anim.method_track_insert_key(bob_track, 0.0, {"method": "set_bob", "args": [0.0]})
	idle_anim.method_track_insert_key(bob_track, 0.5, {"method": "set_bob", "args": [-1.0]})

	var scale_track = idle_anim.add_track(Animation.TYPE_METHOD)
	idle_anim.track_set_path(scale_track, "JohnSprite")
	idle_anim.method_track_insert_key(scale_track, 0.0, {"method": "set_torso_scale", "args": [1.0]})
	idle_anim.method_track_insert_key(scale_track, 0.5, {"method": "set_torso_scale", "args": [1.02]})

	library.add_animation("idle", idle_anim)

	# Walk Cycle
	var walk_anim = Animation.new()
	walk_anim.loop_mode = Animation.LOOP_LINEAR
	walk_anim.length = 0.8

	var walk_frame_track = walk_anim.add_track(Animation.TYPE_METHOD)
	walk_anim.track_set_path(walk_frame_track, "JohnSprite")
	walk_anim.method_track_insert_key(walk_frame_track, 0.0, {"method": "set_frame", "args": [0]})
	walk_anim.method_track_insert_key(walk_frame_track, 0.2, {"method": "set_frame", "args": [1]})
	walk_anim.method_track_insert_key(walk_frame_track, 0.4, {"method": "set_frame", "args": [2]})
	walk_anim.method_track_insert_key(walk_frame_track, 0.6, {"method": "set_frame", "args": [3]})

	var walk_bob_track = walk_anim.add_track(Animation.TYPE_METHOD)
	walk_anim.track_set_path(walk_bob_track, "JohnSprite")
	walk_anim.method_track_insert_key(walk_bob_track, 0.0, {"method": "set_bob", "args": [-2.0]})
	walk_anim.method_track_insert_key(walk_bob_track, 0.2, {"method": "set_bob", "args": [0.0]})
	walk_anim.method_track_insert_key(walk_bob_track, 0.4, {"method": "set_bob", "args": [-2.0]})
	walk_anim.method_track_insert_key(walk_bob_track, 0.6, {"method": "set_bob", "args": [0.0]})

	library.add_animation("walk", walk_anim)

	animation_player.add_animation_library("", library)
