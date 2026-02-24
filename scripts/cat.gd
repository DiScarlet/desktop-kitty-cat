extends CharacterBody2D

#VARS

#constants
const SPEED = 300.0
const MAX_DISTANCE_TO_MOUSE = 100.0
#locals
var is_following_mouse = true



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
	
	global_position += direction * SPEED * delta
	
	update_passthrough()


#system functions
func update_passthrough():
	var shape = $Area2D/CollisionShape2D.shape
	
	if shape is RectangleShape2D:
		var extents = shape.size / 1.7
		
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
