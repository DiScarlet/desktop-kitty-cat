extends Window

#VARS
#constants
const WINDOW_SIZE = Vector2i(386, 281)
const NOTE_LIFETIME = 10
const VELOCITY := Vector2(0, -300)
const ACCELERATION := Vector2(0, 20)
const FADEOUT_TIME = 5
#locals
var dragging = false
var click_position = Vector2()
	#fade out
var is_fading_out = false
var cur_velocity = VELOCITY
#Godot elements
@onready var label: Label = $Sprite2D/Label
@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D
var timer: SceneTreeTimer
#lists/dicts/enums
var notes = [
	"Feed your cat",
	"Stretch your back",
	"Play with your pet",
	"Take a break",
	"Meow, meow, meow"
]

#FUNCS

#system funcs
func _ready() -> void:
	particles.position = Vector2(190.0, 240.0)
	#particles.process_material.spawn.position
	set_process(false)
	setup_instance()
	
func _process(delta: float) -> void:
	if is_fading_out:
		cur_velocity += delta * ACCELERATION
		position += Vector2i(cur_velocity * delta)
		 
#action functions
func show_random_note():
	label.text = notes.pick_random()
	show()
	
#setup funcs
func setup_instance():
	timer = get_tree().create_timer(NOTE_LIFETIME)
	timer.timeout.connect(_on_note_timeout)
	GameManager.kill_note_instance.connect(_on_note_timeout)
		
	GameManager.note_window_id = get_window_id()
	size = WINDOW_SIZE
	
	close_requested.connect(queue_free)

	sprite.position = WINDOW_SIZE / 2
	
#event funcs
func _on_note_timeout():

	particles.emitting = true
	is_fading_out = true
	set_process(true)
	await get_tree().create_timer(FADEOUT_TIME).timeout
	particles.emitting = false
	queue_free()
	
#system funcs
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			click_position = get_viewport().get_mouse_position()
			
	if event is InputEventMouseMotion and dragging:
		position += Vector2i(event.relative)
#helper functions
