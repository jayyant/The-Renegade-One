extends CanvasLayer

signal talking

@onready var text: Label = $TextureRect/Text
@onready var it: Label = $TextureRect/Interact/IT
@onready var text_animate: AnimationPlayer = $TextAnimate
@onready var npc: Area2D = $"../../NPC"
@onready var door: Area2D = $"../../Door"
@onready var rpg_player: CharacterBody2D = %RPGPlayer
@onready var dialogue: CanvasLayer = $"../Dialogue"

@export var interactionType = ""

func _ready() -> void:
	npc.interacted.connect(textMagic)
	door.interacted.connect(textMagic)
	dialogue.hide()


func textMagic():
	match interactionType:
		"NPC":
			text.text = "You have encountered " + npc.get_meta("Name") + "!"
			it.text = "> Talk"
		"Door":
			text.text = "Enter this door?"
			it.text = "> Yes"
		_:
			text.text = ""
			it.text = "> Interact"
	
	text_animate.play("animate text")

func _on_interact_pressed() -> void:
	match interactionType:
		"Door":
			hide()
			rpg_player.position = Vector2(1500, -5500)
			rpg_player.set_physics_process(true)
		"NPC":
			hide()
			dialogue.show()
			if npc.has_meta("Name"):
				dialogue.charName = npc.get_meta("Name")
			talking.emit()
