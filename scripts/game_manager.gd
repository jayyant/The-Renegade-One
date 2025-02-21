extends Node2D

@export var stats: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stats:
		print(stats.enemiesKilled)
		print(stats.friendliesKilled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().create_timer(1).timeout.connect(addone)


func printall():
	print(stats.enemiesKilled)
	print(stats.friendliesKilled)

func addone():
	stats.enemiesKilled += 1
