extends Button

func _on_pressed() -> void:
	GameManager.kill_note_instance.emit()
