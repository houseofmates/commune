extends Node2D
class_name JohnSprite

@export var body_color: Color = Color("#F5E6B8")
@export var pants_color: Color = Color.BLUE
@export var hair_color: Color = Color("#4A2C0A")
@export var shoe_color: Color = Color("#4A2C0A")
@export var eye_color: Color = Color.BLUE

var bob_offset: float = 0.0

func _ready():
	# Ensure visibility on mobile
	scale = Vector2(1.5, 1.5)

func _draw() -> void:
	# Bobbing effect
	var draw_pos = Vector2(0, bob_offset)

	# Pants (Bell-bottoms)
	var pants_poly = PackedVector2Array([
		Vector2(-8, 8) + draw_pos,
		Vector2(8, 8) + draw_pos,
		Vector2(12, 24) + draw_pos,
		Vector2(-12, 24) + draw_pos
	])
	draw_colored_polygon(pants_poly, pants_color)

	# Shoes
	draw_rect(Rect2(-12, 24 + draw_pos.y, 6, 4), shoe_color)
	draw_rect(Rect2(6, 24 + draw_pos.y, 6, 4), shoe_color)

	# Shirt (V-neck)
	var shirt_poly = PackedVector2Array([
		Vector2(-10, -12) + draw_pos,
		Vector2(10, -12) + draw_pos,
		Vector2(8, 8) + draw_pos,
		Vector2(-8, 8) + draw_pos
	])
	draw_colored_polygon(shirt_poly, body_color)
	draw_polyline(PackedVector2Array([Vector2(-4, -12) + draw_pos, Vector2(0, -4) + draw_pos, Vector2(4, -12) + draw_pos]), Color.BLACK, 1.5)

	# Head
	draw_circle(Vector2(0, -18) + draw_pos, 8, Color("#FFE0BD"))

	# Eyes
	draw_circle(Vector2(-3, -20) + draw_pos, 1.5, eye_color)
	draw_circle(Vector2(3, -20) + draw_pos, 1.5, eye_color)

	# Moustache
	draw_rect(Rect2(-4, -16 + draw_pos.y, 8, 2), hair_color)

	# Hair (Curly)
	draw_circle(Vector2(-6, -24) + draw_pos, 4, hair_color)
	draw_circle(Vector2(0, -26) + draw_pos, 4, hair_color)
	draw_circle(Vector2(6, -24) + draw_pos, 4, hair_color)

func set_bob(offset: float) -> void:
	bob_offset = offset
	queue_redraw()
