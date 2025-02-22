extends Control


func _ready() -> void:
	hide()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	hide()
