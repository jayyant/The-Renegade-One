extends Area2D

@onready var game_manager: Node2D = %GameManager

@onready var currentlevel = "level_1"

func get_next_level(lvlname):
	match lvlname:
		"level_1": return "battle"
		"rpg_1": return "level_2"
		"level_2": return "rpg_2"
		"rpg_2": return "level_3"
		"level_3": return "rpg_3"
		"rpg_3": return "level_4"
		"level_4": return "rpg_4"
		"rpg_4": return "level_5"
		"level_5": return "endgame"


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		game_manager.printall()
		var path = "res://scenes/" + get_next_level(currentlevel) +".tscn"
		get_tree().change_scene_to_file(path)
