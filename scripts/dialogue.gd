extends CanvasLayer

@export var charName : String

@onready var interaction_menu: CanvasLayer = $"../InteractionMenu"
@onready var label: Label = $TextureRect/Label
@onready var all_dialogues: Label = $"../../GameManager/AllDialogues" # Ensure this is the correct path
@onready var choices: TextureRect = $Choices
@onready var choice_1_text: Label = $Choices/Choice1/Choice1Text
@onready var choice_2_text: Label = $Choices/Choice2/Choice2Text
@onready var choices_2: TextureRect = $Choices2
@onready var choice_3_text: Label = $Choices2/Choice3/Choice3Text
@onready var choice_4_text: Label = $Choices2/Choice4/Choice4Text
@onready var choice_3: TextureButton = $Choices2/Choice3
@onready var choice_4: TextureButton = $Choices2/Choice4
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
	choices_2.hide()


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
	
	print("Current Dialogue Key: ", current_dialogue_key)
	# Ensure the dialogue dictionary is accessible
	if not all_dialogues \
or (charName == "John Melon" and not all_dialogues.johnmelon.has(current_dialogue_key)) \
or (charName == "George Jams" and not all_dialogues.georgejams.has(current_dialogue_key)) \
or (charName == "Spy" and not all_dialogues.spy.has(current_dialogue_key)) \
or (charName == "Martha" and not all_dialogues.martha.has(current_dialogue_key)):
		print("Error: Dialogue key not found or all_dialogues is not set up correctly.")
		end_dialogue()
		return

	match charName:
		"John Melon":
			current_text = all_dialogues.johnmelon[current_dialogue_key]
		"George Jams":
			current_text = all_dialogues.georgejams[current_dialogue_key]
		"Spy":
			current_text = all_dialogues.spy[current_dialogue_key]
		"Martha":
			current_text = all_dialogues.martha[current_dialogue_key]
	if "Choice1" in current_dialogue_key:
		show_choices_1()
	elif "Choice2" in current_dialogue_key:
		show_choices_2()
	else:
		label.text = current_text
		text_anim.play("textappear")
		choices.hide()  # Hide choices when showing regular dialogue
		choices_2.hide()

func _on_choice_selected(choice_index):
	choices.hide()
	choices_2.hide()
	match charName:
		"John Melon":
			if choice_index == 1:
				current_dialogue_key = "Answer11"
			elif choice_index == 2:
				current_dialogue_key = "Answer12"
				game_manager.badchoiceMade()
		"George Jams":
			if choice_index == 1:
				current_dialogue_key = "Answer11"
			elif choice_index == 2:
				current_dialogue_key = "Answer12"
				game_manager.badchoiceMade()
			if choice_index == 3:
				current_dialogue_key = "Answer21"
			elif choice_index == 4:
				current_dialogue_key = "Answer22"
				game_manager.badchoiceMade()
		"Spy":
			if choice_index == 1:
				current_dialogue_key = "Answer11"
			elif choice_index == 2:
				current_dialogue_key = "Answer12"
				game_manager.badchoiceMade()
			elif choice_index == 3:
				current_dialogue_key = "Answer21"
			elif choice_index == 4:
				current_dialogue_key = "Answer22"
				game_manager.badchoiceMade()
		"Martha":
			if choice_index == 1:
				current_dialogue_key = "AnswerM11"
			elif choice_index == 2:
				current_dialogue_key = "AnswerM12"
				game_manager.badchoiceMade()
	next_button.show()
	skip_button.show()
	display_dialogue()

func end_dialogue():
	hide()  # Hide the CanvasLayer
	is_dialogue_active = false
	rpg_player.set_physics_process(true)

func show_choices_1():
	next_button.hide()
	skip_button.hide()
	label.text = current_text
	text_anim.play("textappear")
	match charName:
		"John Melon":
			choice_1_text.text = "Tell the truth"
			choice_2_text.text = "Lie."
		"George Jams":
			choice_1_text.text = "'You'll always be remembered as a hero.'"
			choice_2_text.text = "'Maybe you have a point...'"
		"Spy":
			choice_1_text.text = "The Big Boys"
			choice_2_text.text = "The Wing Men"
		"Martha":
			choice_1_text.text = "'I'm so sorry, but he was K.I.A"
			choice_2_text.text = "'Yes, I just reported to him recently'"
	get_tree().create_timer(0.4).timeout.connect(choices.show)

func show_choices_2():
	next_button.hide()
	skip_button.hide()
	label.text = current_text
	text_anim.play("textappear")
	match charName:
		"George Jams":
			choice_3_text.text = "'Atleast your kids will have a father in their lives'"
			choice_4_text.text = "'Ah you're right. It's useless'"
		"Spy":
			choice_3_text.text = "Report him to the enforcers"
			choice_4_text.text = "Give him the plans"
	get_tree().create_timer(0.4).timeout.connect(choices_2.show)

func get_next_key() -> String:
	match charName:
		"John Melon":
			match current_dialogue_key:
						"Intro": return "Line1"
						"Line1": return "Line2"
						"Line2": return "Choice1"
						"Answer11", "Answer12": return "Line3"
						"Line3": return "Line4"
						"Line4": return "Final"
						"Final": return ""
						"Skip": return ""
		"George Jams":
			match current_dialogue_key:
				"Intro": return "Line1"
				"Line1": return "Line2"
				"Line2": return "Line3"
				"Line3": return "Line4"
				"Line4": return "Choice1"
				"Answer11": return "Line51"
				"Answer12": return "Line52"
				"Line51": return "Choice2"
				"Line52": return "Final"
				"Answer21", "Answer22": return "Final"
				"Final": return ""
				"Skip": return ""
		"Spy":
			match current_dialogue_key:
				"Intro": return "Choice1"
				"AnswerS11": return "Final"
				"AnswerS12": return "Line1"
				"Line1": return "Line2"
				"Line2": return "Line3"
				"Line3": return "Line4"
				"Line4": return "Choice2"
				"AnswerS21","AnswerS22": return "Final"
				"Final": return ""
				"Skip": return ""
		"Martha":
			match current_dialogue_key:
				"Intro": return "Line1"
				"Line1": return "Line2"
				"Line2": return "Choice1"
				"Answer11","Answer12": return "Final"
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

func _on_skip_button_pressed() -> void:
	skip_button.hide()
	current_dialogue_key = "Skip"
	display_dialogue()


func _on_choice_3_pressed() -> void:
	_on_choice_selected(3)


func _on_choice_4_pressed() -> void:
	_on_choice_selected(4)
