extends Area2D

signal neardoor
signal notneardoor

var nearby = false
@onready var interaction_menu: CanvasLayer = $"../RPGPlayer/InteractionMenu"
@onready var rpg_player: CharacterBody2D = %RPGPlayer


func _ready() -> void:
	rpg_player.interaction.connect(interactionCore)
	interaction_menu.hide()


func _on_body_entered(body: Node2D) -> void:
	if body == rpg_player:
		nearby = true
		neardoor.emit()



func interactionCore():
	if nearby:
		rpg_player.position = Vector2(1500, -5500)


func _on_body_exited(body: Node2D) -> void:
	if body == rpg_player:
		nearby = false
		notneardoor.emit()
