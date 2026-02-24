extends Node2D

#VARS

#constants
const CAT_SIZE_MULTIPLYER = 5.0

#Godot elements
@onready var cat: CharacterBody2D = $Cat


#FUNCS

#system funcs
func _ready() -> void:
	setup_transparent_window()
	setup_cat()
	
func _process(delta: float) -> void:
	pass
	
#setup funcs
func setup_transparent_window() -> void:
	var window = get_window()
	
	var size = DisplayServer.screen_get_size()
	DisplayServer.window_set_size(size + Vector2i(2, 2))
	
	get_viewport().transparent_bg = true
	window.transparent = true
	
	window.borderless = true
	window.always_on_top = true
	
	window.unresizable = false
	
func setup_cat() -> void:
	cat.scale = Vector2.ONE * CAT_SIZE_MULTIPLYER
	
#systeem functions

		
#event management funcs

	
