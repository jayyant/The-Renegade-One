extends Area2D

signal death

@onready var player: CharacterBody2D = %Player




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("death")
