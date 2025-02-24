<<<<<<< HEAD
extends Area2D

signal death

@onready var player: CharacterBody2D = %Player




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("death")
=======
extends StaticBody2D

@onready var player: CharacterBody2D = %Player

func _on_body_entered():
	print("Dead")
>>>>>>> eb2ea85023fc6bb1a578b945c20dd3daad267f17
