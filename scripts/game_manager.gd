extends Node2D

@export var stats: Resource

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
