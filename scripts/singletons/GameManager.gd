extends Node

#SIGNALS
	#mouse follow
signal cat_start_mouse_follow
signal change_cat_state(new_state: CatState)

	#notes
signal bring_note


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
	#mouse follow
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			cat_start_mouse_follow.emit()
			print("Cat follows the mouse!")
			
	#notes
	if event is InputEventKey:
		if event.pressed:
			bring_note.emit()
			print("Cat will bring the note!")
	
