extends Node2D

#VARS

#constants
const CAT_SIZE_MULTIPLYER = 1.0
const WINDOW_SIZE = Vector2i(200, 180)
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
	
	window.size = WINDOW_SIZE
	
func setup_cat() -> void:
	cat.scale = Vector2.ONE * CAT_SIZE_MULTIPLYER
	cat.center_sprite()
	
#systeem functions

		
#event management funcs

	
