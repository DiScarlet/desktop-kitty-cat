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
#lists/dicts
var DIRECTIONS = ["t", "b", "r", "l", "tl", "bl", "tr", "br"]


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
	var mouse_screen = Vector2(DisplayServer.mouse_get_position()) 
	var window_screen = Vector2(DisplayServer.window_get_position()) 
	var window_size = Vector2(DisplayServer.window_get_size()) 

	print("mouse_screen: " + str(mouse_screen)) 
	print("window_screen: " + str(window_screen)) 
	print("window_size: " + str(window_size)) 

	var cat_screen = window_screen + window_size / 2 # 
	var distance: float = cat_screen.distance_to(mouse_screen) 

	if distance < MAX_DISTANCE_TO_MOUSE: 
		return 
		
	var direction = cat_screen.direction_to(mouse_screen) 
	play_correct_animation(determine_animation_direction(direction), "walk") 
	window_screen += Vector2(direction * SPEED * delta) 
	DisplayServer.window_set_position(window_screen)

#system functions

#signal functions
func on_start_mouse_follow():
	is_following_mouse = true

func on_stop_mouse_follow():
	is_following_mouse = false

#helper functions
func determine_animation_direction(direction) -> String:
	var angle = rad_to_deg(direction.angle())

	if angle < 0:
		angle += 360

	if angle >= 337.5 or angle < 22.5:
		return "r"
	elif angle < 67.5:
		return "br"
	elif angle < 112.5:
		return "b"
	elif angle < 157.5:
		return "bl"
	elif angle < 202.5:
		return "l"
	elif angle < 247.5:
		return "tl"
	elif angle < 292.5:
		return "t"
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
