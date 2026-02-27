extends Node

#SIGNALS
signal cat_start_mouse_follow
signal change_cat_state(new_state: CatState)

#VARS
#lists/dicts/enums
enum CatState {
	WALKING,
	SITTING,
	LAYING,
	IDLE_START
}


#FUNCS
#system functions
func _ready() -> void:
	pass
	
	
#event fuctions
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			cat_start_mouse_follow.emit()
			print("Cat follows the mouse!")
