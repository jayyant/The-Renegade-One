extends Area2D

signal near
signal notnear
signal interacted

var nearby = false
@onready var interaction_menu: CanvasLayer = $"../RPGPlayer/InteractionMenu"
@onready var rpg_player: CharacterBody2D = %RPGPlayer


func _ready() -> void:
	rpg_player.interaction.connect(interactionCore)
	interaction_menu.hide()

func _on_body_entered(body: Node2D) -> void:
	interaction_menu.interactionType = "NPC"
	if body == rpg_player:
		nearby = true
		near.emit()



func interactionCore():
	if nearby:
		emit_signal("interacted")
		interaction_menu.show()
		rpg_player.set_physics_process(false)


func _on_body_exited(body: Node2D) -> void:
	if body == rpg_player:
		nearby = false
		notnear.emit()
