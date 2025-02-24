extends Control

@onready var player: CharacterBody2D = %Player

func _ready() -> void:
	hide()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	hide()
	player.set_physics_process(true)
