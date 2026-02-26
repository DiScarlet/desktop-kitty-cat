extends Node2D

#VARS

#constants
const CAT_SIZE_MULTIPLYER = 1.0

#Godot elements
@onready var cat: CharacterBody2D = $Cat


#FUNCS

#system funcs
func _ready() -> void:
	setup_transparent_window()
	setup_cat()
	
#setup funcs
func setup_transparent_window() -> void:
	var window = get_window()
	
	get_viewport().transparent_bg = true
	window.transparent = true
	
	window.borderless = true
	window.always_on_top = true
	
	window.unresizable = false
	
	window.size = Vector2i(200, 200)
	
func setup_cat() -> void:
	cat.scale = Vector2.ONE * CAT_SIZE_MULTIPLYER
	
#systeem functions

		
#event management funcs

	
