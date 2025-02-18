extends CanvasLayer


@export var charName : String

@onready var interaction_menu: CanvasLayer = $"../InteractionMenu"
@onready var label: Label = $TextureRect/Label
@onready var all_dialogues: Label = $"../../GameManager/AllDialogues"


func _ready() -> void:
	interaction_menu.talking.connect(speak)

func speak():
	match charName:
		"John Melon":
				for words in all_dialogues.johnmelon:
					#get_tree().create_timer(2).timeout.connect()
					label.text = all_dialogues.johnmelon[words]
