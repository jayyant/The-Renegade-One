extends Resource

@export var enemiesKilled: int
@export var friendliesKilled: int
@export var bad_choices: int
func _init(p_enemiesKilled = 0, p_friendliesKilled = 0, p_badchoices = 0) -> void:
	enemiesKilled = p_enemiesKilled
	friendliesKilled = p_friendliesKilled
	bad_choices = p_badchoices
