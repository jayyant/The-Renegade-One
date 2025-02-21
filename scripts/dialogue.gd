extends CanvasLayer

@export var charName : String

@onready var interaction_menu: CanvasLayer = $"../InteractionMenu"
@onready var label: Label = $TextureRect/Label
@onready var all_dialogues: Label = $"../../GameManager/AllDialogues" # Ensure this is the correct path
@onready var choices: TextureRect = $Choices
@onready var choice_1_text: Label = $Choices/Choice1/Choice1Text
@onready var choice_2_text: Label = $Choices/Choice2/Choice2Text
@onready var choice_1: TextureButton = $Choices/Choice1
@onready var choice_2: TextureButton = $Choices/Choice2
@onready var character_name: Label = $CharacterName
@onready var rpg_player: CharacterBody2D = %RPGPlayer
@onready var skip_button: TextureButton = $HBoxContainer/SkipButton
@onready var next_button: TextureButton = $HBoxContainer/NextButton
@onready var text_anim: AnimationPlayer = $TextAnim
@onready var game_manager: Node2D = %GameManager

var current_dialogue_key = ""
var is_dialogue_active = false
var current_text

func _ready() -> void:
	interaction_menu.talking.connect(start_dialogue)
	choices.hide()


func start_dialogue():
	character_name.text = charName
	current_dialogue_key = "Intro"
	is_dialogue_active = true
	show()  # Ensure the CanvasLayer is visible
	display_dialogue()
	skip_button.show()
	next_button.show()

#func _process(delta: float) -> void:
	#print(current_dialogue_key)

func display_dialogue():
	if current_dialogue_key == "":
		end_dialogue()
		return
	
	# Ensure the dialogue dictionary is accessible
	if not all_dialogues or not all_dialogues.johnmelon.has(current_dialogue_key):
		print("Error: Dialogue key not found or all_dialogues is not set up correctly.")
		end_dialogue()
		return
	
	current_text = all_dialogues.johnmelon[current_dialogue_key]
	
	if "Choice" in current_dialogue_key:
		show_choices()
	else:
		label.text = current_text
		text_anim.play("textappear")
		choices.hide()  # Hide choices when showing regular dialogue

func _on_choice_selected(choice_index):
	choices.hide()
	match charName:
		"John Melon":
			if choice_index == 1:
				current_dialogue_key = "Answer11"
			elif choice_index == 2:
				current_dialogue_key = "Answer12"
			else:
				get_next_key()
	
	next_button.show()
	skip_button.show()
	display_dialogue()

func end_dialogue():
	hide()  # Hide the CanvasLayer
	is_dialogue_active = false
	rpg_player.set_physics_process(true)

func show_choices():
	next_button.hide()
	skip_button.hide()
	label.text = current_text
	text_anim.play("textappear")
	match charName:
		"John Melon":
			choice_1_text.text = "Tell the truth"
			choice_2_text.text = "Lie."
	get_tree().create_timer(0.4).timeout.connect(choices.show)

func get_next_key() -> String:
	match current_dialogue_key:
		"Intro": return "Line1"
		"Line1": return "Line2"
		"Line2": return "Choice1"
		"Answer11", "Answer12": return "Line3"
		"Choice1": return "Line3"
		"Line3": return "Line4"
		"Line4": return "Final"
		"Final": return ""
		"Skip": return ""
	return ""


func _on_next_button_pressed() -> void:
	if text_anim.is_playing() == true:
		text_anim.stop()
		label.visible_ratio = 1
	else:
		current_dialogue_key = get_next_key()
		display_dialogue()


func _on_choice_1_pressed() -> void:
	_on_choice_selected(1)


func _on_choice_2_pressed() -> void:
	_on_choice_selected(2)
	game_manager.printall()

func _on_skip_button_pressed() -> void:
	skip_button.hide()
	current_dialogue_key = "Skip"
	display_dialogue()
