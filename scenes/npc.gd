extends Area2D

var nearby = false
@onready var rpg_player: CharacterBody2D = $"../RPGPlayer"


func _ready() -> void:
	rpg_player.interaction.connect(interactionCore)

func _on_body_entered(body: Node2D) -> void:
	nearby = true


func interactionCore():
	if nearby:
		print("Interaction success!")


func _on_body_exited(body: Node2D) -> void:
	nearby = false
