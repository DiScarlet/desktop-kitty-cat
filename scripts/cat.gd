class_name Cat
extends CharacterBody2D

#VARS

#constants
	#mouse follow
const SPEED = 300.0
const START_DISTANCE = 140.0
const STOP_DISTANCE = 100.0
const TIME_IDLE_TO_LAYING = 5.0
const CatState = GameManager.CatState
	#notes
const NOTE_SCENE = preload("res://scenes/AdditionalScenes/note_screen.tscn")
const NOTE_OFFSET := Vector2i(-340, 0)
#locals
	#mouse follow
var is_following_mouse = false
var current_state: GameManager.CatState = GameManager.CatState.IDLE_START
var animation_direction: String = "b"
var idle_direction: String = "b"
	#notes
var is_bringing_note = false
var note_instance = null
var note_stage = NoteStage.BORDER_1
var target_border: Vector2
var return_position: Vector2
#Godot elements
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
#lists/dicts/enums
enum NoteStage {
	BORDER_1,
	BRINGING_OUT_2,
	SHOWING_3
}


#FUNCS

#system funcs
func _ready() -> void:
	#subscribe to signals
		#mouse follow
	GameManager.cat_start_mouse_follow.connect(on_start_mouse_follow)
	GameManager.change_cat_state.connect(on_change_cat_state)
		#notes
	GameManager.bring_note.connect(on_bring_note)
	#initialize variables
	GameManager.cat = self
	
	
func _physics_process(delta):
	#mouse follow
	if is_following_mouse:
		follow_mouse(delta)
		return
		
	#notes
	if is_bringing_note:
		process_note(delta)

#action functions
	#universal
func go_to_location(window_screen, distance, direction, cur_animation_direction, delta):
	if distance <= STOP_DISTANCE:
		return true
		
	if current_state != CatState.WALKING:
		current_state = CatState.WALKING
		play_correct_animation(cur_animation_direction, "walk", false) 
	else:
		play_correct_animation(cur_animation_direction, "walk") 	
	
	window_screen += Vector2(direction * SPEED * delta) 
	DisplayServer.window_set_position(window_screen)
	
	return false
	

	#mouse follow
func follow_mouse(delta):
	var mouse_screen = Vector2(DisplayServer.mouse_get_position()) 
	var anim_vars = get_default_animation_vars(mouse_screen)
		
	if current_state == CatState.WALKING and anim_vars.distance < STOP_DISTANCE:
		manage_sitting(anim_vars.cur_animation_direction)
		return
		
	#TODO: FIX IT HERE
	#Walking logic		
	if anim_vars.distance >= START_DISTANCE:
		go_to_location(anim_vars.window_screen, anim_vars.distance, anim_vars.direction, anim_vars.cur_animation_direction, delta)

func manage_sitting(cur_animation_direction):
	if current_state != CatState.WALKING:
		return
		
	current_state = CatState.SITTING
	idle_direction = cur_animation_direction
	
	print(CatState.keys()[current_state] + " in direction: " + idle_direction)
	
	play_correct_animation(idle_direction, "sit", false) 
		
	await get_tree().create_timer(TIME_IDLE_TO_LAYING).timeout
	
	if current_state == CatState.SITTING:
		manage_laying()
	
func manage_laying():
	if current_state != CatState.SITTING:
		return
		
	current_state = CatState.LAYING
	print(CatState.keys()[current_state] + " in direction: " + idle_direction)
	
	play_correct_animation(idle_direction, "lay", false)
	
		#notes
			#cat's logic
func show_note():
	if note_instance == null:
		note_instance = NOTE_SCENE.instantiate()
		get_tree().root.add_child(note_instance)
		
	var cat_screen = DisplayServer.window_get_position()
	var note_offset = Vector2i(200, 0)

	note_instance.position = cat_screen + note_offset
	note_instance.show_random_note()
	
func start_going_to_border():
	target_border = find_closest_screen_border()
	
	var window_screen = Vector2(DisplayServer.window_get_position()) 
	var window_size = Vector2(DisplayServer.window_get_size()) 

	return_position = window_screen + window_size / 2

	note_stage = NoteStage.BORDER_1
	
func process_go_to_border(delta):
	var anim_vars = get_default_animation_vars(target_border)
	var reached = go_to_location(anim_vars.window_screen, anim_vars.distance, anim_vars.direction, anim_vars.cur_animation_direction, delta)
	
	if reached:
		note_stage = NoteStage.BRINGING_OUT_2
		show_note()
	
func process_bring_note(delta):
	var anim_vars = get_default_animation_vars(return_position)
	var reached = go_to_location(anim_vars.window_screen, anim_vars.distance, anim_vars.direction, anim_vars.cur_animation_direction, delta)
	
	update_note_position()
	
	if reached:
		note_stage = NoteStage.SHOWING_3
		
func show_note_finish():
	sprite.play("lay_l") #TODO: Change to real lay
	is_bringing_note = false
	
			#notes's logic
func update_note_position():
	if GameManager.note_window_id == -1:
		return
		
	var cat_window_pos = DisplayServer.window_get_position()
	var note_pos = cat_window_pos + NOTE_OFFSET
	
	DisplayServer.window_set_position(note_pos, GameManager.note_window_id)

#system functions
func center_sprite():
	if sprite:
		sprite.global_position = get_viewport_rect().size / 2
	
func get_current_state() -> GameManager.CatState:
	return current_state
	
#signal functions
	#mouse follow
func on_start_mouse_follow():
	is_following_mouse = true
	current_state = CatState.WALKING

func on_stop_mouse_follow():
	is_following_mouse = false

func on_change_cat_state(new_state: CatState):
	current_state = new_state
	
	#notes
func on_bring_note():
	start_going_to_border()
	is_following_mouse = false
	is_bringing_note = true
	
#helper functions
	#universal
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
		
		
func play_correct_animation(current_direction: String, animation_name: String, check_for_same_direction: bool = true) -> void:
	# Do nothing if direction didn't change
	if check_for_same_direction:
		if animation_direction == current_direction:
			return
		
	animation_direction = current_direction

	var animation_to_play = animation_name + "_" + current_direction
	
	if sprite.sprite_frames.has_animation(animation_to_play):
		sprite.play(animation_to_play)
		
func get_default_animation_vars(target_position: Vector2i):
	var window_screen = Vector2(DisplayServer.window_get_position()) 
	var window_size = Vector2(DisplayServer.window_get_size()) 

	var cat_screen = window_screen + window_size / 2 
	var distance: float = cat_screen.distance_to(target_position) 
	var direction = cat_screen.direction_to(target_position)
	
	return {
		"window_screen": window_screen,
		"distance": distance,
		"direction": direction,
		"cur_animation_direction": determine_animation_direction(direction)
	}	
		
	#notes
static func get_abs_screen_position() -> Vector2i:
	return DisplayServer.window_get_position()
		
func find_closest_screen_border() -> Vector2i:
	var cur_abs = Cat.get_abs_screen_position()
	var cur_x = cur_abs.x
	var win_x = DisplayServer.screen_get_size().x
	var target_x
	
	if cur_x <= win_x / 2:
		target_x = 0
	else:
		target_x = win_x
		
	return Vector2i(target_x, cur_abs.y)
	
func process_note(delta):
	match note_stage:
		NoteStage.BORDER_1:
			process_go_to_border(delta)		
			return
			
		NoteStage.BRINGING_OUT_2:
			process_bring_note(delta)
			return
			
		NoteStage.SHOWING_3:
			show_note_finish()
			return
