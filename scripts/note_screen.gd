extends Window

#VARS
#constants
const WINDOW_SIZE = Vector2i(386, 281)
const NOTE_TIMELIFE = 60
#locals
var dragging = false
var click_position = Vector2()
#Godot elements
@onready var label: Label = $Sprite2D/Label
@onready var sprite: Sprite2D = $Sprite2D
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
	setup_instance()
	
	
#action functions
func show_random_note():
	label.text = notes.pick_random()
	show()
	
#setup funcs
func setup_instance():
	timer = get_tree().create_timer(NOTE_TIMELIFE)
	timer.timeout.connect(_on_note_timeout)
	GameManager.kill_note_instance.connect(_on_note_timeout)
		
	GameManager.note_window_id = get_window_id()
	size = WINDOW_SIZE
	
	close_requested.connect(queue_free)

	sprite.position = WINDOW_SIZE / 2
	
#event funcs
func _on_note_timeout():
	#TODO: CREATE A FUNC THAT LAUNCHES UP THE NOTE OR MAKES IT GO OUT BEUTIFULLT
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
