extends Window

#VARS
#constants
const WINDOW_SIZE = Vector2i(386, 281)
#locals
var dragging = false
var click_position = Vector2()
#Godot elements
@onready var label: Label = $Sprite2D/Label
@onready var sprite: Sprite2D = $Sprite2D
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
	GameManager.note_window_id = get_window_id()
	size = WINDOW_SIZE
	sprite.global_position = WINDOW_SIZE / 2
	
#system funcs
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			click_position = get_viewport().get_mouse_position()
			
	if event is InputEventMouseMotion and dragging:
		position += Vector2i(event.relative)
#helper functions
