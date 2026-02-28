extends Window

#VARS
#constants
const WINDOW_SIZE = Vector2i(400, 228)
#locals
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
	size = WINDOW_SIZE
	sprite.global_position = WINDOW_SIZE / 2
	
#helper functions
#func find_closest_screen_border():
