extends CharacterBody2D

#VARS

#constants
const SPEED = 300.0
const MAX_DISTANCE_TO_MOUSE = 100.0
#locals
var is_following_mouse = true
var animation_direction
#Godot elements
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


#FUNCS

#system funcs
func _ready() -> void:

#subscribe to signals
	GameManager.cat_start_mouse_follow.connect(on_start_mouse_follow)

func _physics_process(delta):
	if is_following_mouse:
		follow_mouse(delta)

#action functions
func follow_mouse(delta):
	var mouse_position = get_global_mouse_position()
	
	if global_position.distance_to(mouse_position) < MAX_DISTANCE_TO_MOUSE:
		velocity = Vector2.ZERO
		return

	var direction = global_position.direction_to(mouse_position)

	play_correct_animation(determine_animation_direction(direction), "walk")

	global_position += direction * SPEED * delta

	update_passthrough()




#system functions
func update_passthrough():
	var shape = $Area2D/CollisionShape2D.shape

	var extents
	if shape is RectangleShape2D:
		extents = shape.size / 1
	
	var points = [
	Vector2(-extents.x, -extents.y),
	Vector2(extents.x, -extents.y),
	Vector2(extents.x, extents.y),
	Vector2(-extents.x, extents.y)
	]
	
	var global_points := PackedVector2Array()
	
	for p in points:
		global_points.append($Area2D.to_global(p))
	
	get_window().mouse_passthrough_polygon = global_points
	

#signal functions
func on_start_mouse_follow():
	is_following_mouse = true

func on_stop_mouse_follow():
	is_following_mouse = false

#helper functions
func determine_animation_direction(direction: Vector2) -> String:
	var angle = rad_to_deg(direction.angle())
	
	if angle < 0:
		angle += 360
	
	# Right
	if angle >= 337.5 or angle < 22.5:
		return "r"
	# Bottom Right
	elif angle < 67.5:
		return "br"
	# Bottom
	elif angle < 112.5:
		return "b"
	# Bottom Left
	elif angle < 157.5:
		return "bl"
	# Left
	elif angle < 202.5:
		return "l"
	# Top Left
	elif angle < 247.5:
		return "tl"
	# Top
	elif angle < 292.5:
		return "t"
	# Top Right
	else:
		return "tr"
		
	
func play_correct_animation(current_direction: String, animation_name: String) -> void:
	# Do nothing if direction didn't change
	if animation_direction == current_direction:
		return
		
	animation_direction = current_direction

	var animation_to_play = animation_name + "_" + current_direction

	if sprite.sprite_frames.has_animation(animation_to_play):
		sprite.play(animation_to_play)
