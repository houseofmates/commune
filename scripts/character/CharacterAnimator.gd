extends Node
class_name CharacterAnimator

@onready var parent: CharacterController = get_parent()
@onready var john_sprite: JohnSprite = parent.get_node("JohnSprite")
@onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")

func _ready() -> void:
	if not animation_player.has_animation("idle"):
		_create_animations()
	animation_player.play("idle")

func _process(_delta: float) -> void:
	if parent.velocity.length() > 0:
		if animation_player.current_animation != "walk":
			animation_player.play("walk")
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")

func _create_animations() -> void:
	var library = AnimationLibrary.new()

	# Idle
	var idle_anim = Animation.new()
	idle_anim.loop_mode = Animation.LOOP_LINEAR
	var track = idle_anim.add_track(Animation.TYPE_METHOD)
	idle_anim.track_set_path(track, "JohnSprite")
	idle_anim.method_track_insert_key(track, 0.0, {"method": "set_bob", "args": [0.0]})
	idle_anim.method_track_insert_key(track, 1.0, {"method": "set_bob", "args": [-2.0]})
	idle_anim.method_track_insert_key(track, 2.0, {"method": "set_bob", "args": [0.0]})
	idle_anim.length = 2.0
	library.add_animation("idle", idle_anim)

	# Walk
	var walk_anim = Animation.new()
	walk_anim.loop_mode = Animation.LOOP_LINEAR
	track = walk_anim.add_track(Animation.TYPE_METHOD)
	walk_anim.track_set_path(track, "JohnSprite")
	walk_anim.method_track_insert_key(track, 0.0, {"method": "set_bob", "args": [0.0]})
	walk_anim.method_track_insert_key(track, 0.25, {"method": "set_bob", "args": [-5.0]})
	walk_anim.method_track_insert_key(track, 0.5, {"method": "set_bob", "args": [0.0]})
	walk_anim.method_track_insert_key(track, 0.75, {"method": "set_bob", "args": [-5.0]})
	walk_anim.length = 0.5
	library.add_animation("walk", walk_anim)

	animation_player.add_animation_library("", library)
