extends StaticBody2D

@onready var player: CharacterBody2D = %Player

func _on_body_entered():
	print("Dead")
