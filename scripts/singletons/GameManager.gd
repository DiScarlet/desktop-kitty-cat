extends Node

#SIGNALS
signal cat_start_mouse_follow


#system functions
func _ready() -> void:
	pass
	
	
#event fuctions
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			cat_start_mouse_follow.emit()
			print("Cat follows the mouse!")
