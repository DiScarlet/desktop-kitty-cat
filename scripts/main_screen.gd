extends Node2D

#vars

#constants
const CAT_SIZE_MULTIPLYER = 3.0

#Godot elements
@onready var cat: CharacterBody2D = $Cat



#funcs
func _ready() -> void:
	setup_transparent_window()
	setup_cat()
	
func setup_transparent_window() -> void:
	var window = get_window()
	
	get_viewport().transparent_bg = true
	window.transparent = true
	
	window.borderless = true
	window.always_on_top = true
	
	window.unresizable = false
	
func setup_cat() -> void:
	cat.scale = Vector2.ONE * CAT_SIZE_MULTIPLYER
