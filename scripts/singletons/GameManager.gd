extends Node

#SIGNALS
	#mouse follow
signal cat_start_mouse_follow
signal change_cat_state(new_state: CatState)
	#notes
signal bring_note
signal kill_note_instance

#VARS
#Globals(for the project), locals(for GameManager)
var note_window_id
#lists/dicts/enums
enum CatState {
	WALKING,
	SITTING,
	LAYING,
	IDLE_START,
}
#object instances
var cat: Cat

#FUNCS
#system functions
func _ready() -> void:
	#GlobalKeyboard.KeyPressed.connect(_on_global_key)
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
		if cat and event.pressed:
			var cat_state = cat.get_current_state()
			if cat_state == CatState.SITTING or cat_state == CatState.LAYING:
				bring_note.emit()
				print("Cat will bring the note!")
	
'''func _on_global_key():
	if cat:
		var cat_state = cat.get_current_state()
		if cat_state == CatState.SITTING or cat_state == CatState.LAYING:
			bring_note.emit()
			print("Cat will bring the note!")'''
