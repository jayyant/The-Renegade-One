extends Node2D

@export var stats: Resource

@export var enkill : int
@export var frkill : int
@export var choice : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stats:
		print(stats.enemiesKilled)
		print(stats.friendliesKilled)



func printall():
	print(stats.enemiesKilled)
	print(stats.friendliesKilled)

func enemyKilled():
	stats.enemiesKilled += 1

func badchoiceMade():
	stats.bad_choices += 1

func friendlyKilled():
	stats.friendliesKilled += 1

func getKillsE():
	enkill = stats.enemiesKilled
	return enkill

func getKillsF():
	frkill = stats.friendliesKilled
	return frkill

func getChoices():
	choice = stats.bad_choices
	return choice
