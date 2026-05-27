extends Node2D
class_name JohnSprite

@export var body_color: Color = Color("#F5E6B8")
@export var pants_color: Color = Color.BLUE
@export var hair_color: Color = Color("#4A2C0A")
@export var shoe_color: Color = Color("#4A2C0A")
@export var eye_color: Color = Color.BLUE

var bob_offset: float = 0.0
var current_frame: int = 0
var torso_scale: float = 1.0

func _ready():
	# Ensure visibility on mobile
	scale = Vector2(1.5, 1.5)

func set_frame(frame: int) -> void:
	current_frame = frame
	queue_redraw()

func set_bob(offset: float) -> void:
	bob_offset = offset
	queue_redraw()

func set_torso_scale(s: float) -> void:
	torso_scale = s
	queue_redraw()

func _draw() -> void:
	var draw_pos = Vector2(0, bob_offset)

	# Leg and Arm offsets based on frame
	# Frame 0: Left leg forward, right leg back, left arm back, right arm forward
	# Frame 1: Neutral midpoint
	# Frame 2: Right leg forward, left leg back, right arm back, left arm forward
	# Frame 3: Neutral midpoint

	var l_leg_off = 0.0
	var r_leg_off = 0.0
	var l_arm_off = 0.0
	var r_arm_off = 0.0

	match current_frame:
		0:
			l_leg_off = 4.0
			r_leg_off = -4.0
			l_arm_off = -4.0
			r_arm_off = 4.0
		2:
			l_leg_off = -4.0
			r_leg_off = 4.0
			l_arm_off = 4.0
			r_arm_off = -4.0

	# Legs (Bell-bottoms)
	_draw_leg(Vector2(-4, 8) + draw_pos, l_leg_off)
	_draw_leg(Vector2(4, 8) + draw_pos, r_leg_off)

	# Arms
	_draw_arm(Vector2(-10, -8) + draw_pos, l_arm_off)
	_draw_arm(Vector2(10, -8) + draw_pos, r_arm_off)

	# Torso (Shirt)
	var torso_pos = draw_pos
	var shirt_poly = PackedVector2Array([
		Vector2(-10, -12) * torso_scale + torso_pos,
		Vector2(10, -12) * torso_scale + torso_pos,
		Vector2(8, 8) * torso_scale + torso_pos,
		Vector2(-8, 8) * torso_scale + torso_pos
	])
	draw_colored_polygon(shirt_poly, body_color)
	draw_polyline(PackedVector2Array([
		Vector2(-4, -12) * torso_scale + torso_pos,
		Vector2(0, -4) * torso_scale + torso_pos,
		Vector2(4, -12) * torso_scale + torso_pos
	]), Color.BLACK, 1.5)

	# Head
	var head_pos = Vector2(0, -18) + draw_pos
	draw_circle(head_pos, 8, Color("#FFE0BD"))

	# Eyes
	draw_circle(head_pos + Vector2(-3, -2), 1.5, eye_color)
	draw_circle(head_pos + Vector2(3, -2), 1.5, eye_color)

	# Moustache
	draw_rect(Rect2(head_pos.x - 4, head_pos.y + 2, 8, 2), hair_color)

	# Hair (Curly)
	draw_circle(head_pos + Vector2(-6, -6), 4, hair_color)
	draw_circle(head_pos + Vector2(0, -8), 4, hair_color)
	draw_circle(head_pos + Vector2(6, -6), 4, hair_color)

func _draw_leg(base_pos: Vector2, offset: float) -> void:
	var poly = PackedVector2Array([
		base_pos,
		base_pos + Vector2(8, 0),
		base_pos + Vector2(8 + offset, 16),
		base_pos + Vector2(offset, 16)
	])
	draw_colored_polygon(poly, pants_color)
	# Shoe
	draw_rect(Rect2(base_pos.x + offset, base_pos.y + 16, 8, 4), shoe_color)

func _draw_arm(base_pos: Vector2, offset: float) -> void:
	var poly = PackedVector2Array([
		base_pos,
		base_pos + Vector2(2, 0),
		base_pos + Vector2(2 + offset, 12),
		base_pos + Vector2(offset, 12)
	])
	draw_colored_polygon(poly, body_color)
