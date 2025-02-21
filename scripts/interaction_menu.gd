extends CanvasLayer

signal talking

@onready var text: Label = $TextureRect/Text
@onready var it: Label = $TextureRect/Interact/IT
@onready var text_animate: AnimationPlayer = $TextAnimate
@onready var npc: Area2D = $"../../NPC"
@onready var door: Area2D = $"../../Door"
@onready var rpg_player: CharacterBody2D = %RPGPlayer
@onready var dialogue: CanvasLayer = %Dialogue

@export var interactionType = ""

func _ready() -> void:
	if npc:
		npc.interacted.connect(textMagic)
	else:
		print("npc not found")
	if dialogue:
		dialogue.hide()
	else:
		print("dialogue not found")


func textMagic():
	match interactionType:
		"NPC":
			text.text = "You have encountered " + npc.get_meta("Name") + "!"
			it.text = "> Talk"
		_:
			text.text = ""
			it.text = "> Interact"
	
	text_animate.play("animate text")

func _on_interact_pressed() -> void:
	match interactionType:
		"NPC":
			hide()
			dialogue.show()
			if npc.has_meta("Name"):
				dialogue.charName = npc.get_meta("Name")
			talking.emit()
