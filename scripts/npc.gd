extends Area2D

var nearby = false
@onready var rpg_player: CharacterBody2D = $"../RPGPlayer"


func _ready() -> void:
	rpg_player.interaction.connect(interactionCore)

func _on_body_entered(body: Node2D) -> void:
<<<<<<< HEAD
	interaction_menu.interactionType = "NPC"
	if body == rpg_player:
		nearby = true
		near.emit()

=======
	nearby = true
>>>>>>> bdeb3de98154b32f805aea209b8d4454e91248ea


func interactionCore():
	if nearby:
		print("Interaction success!")


func _on_body_exited(body: Node2D) -> void:
<<<<<<< HEAD
	if body == rpg_player:
		nearby = false
		notnear.emit()
=======
	nearby = false
>>>>>>> bdeb3de98154b32f805aea209b8d4454e91248ea
