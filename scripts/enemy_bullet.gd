extends CharacterBody2D

signal bullethitEnemy(collider)

var speed: float = 1000.0
var direction: float = 0.0  

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed, 0).rotated(direction)

	var collision = move_and_collide(Vector2(speed, 0).rotated(direction) * delta)

	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("player"):
			bullethitEnemy.emit()
			queue_free()
		elif collider.is_in_group("tilemap"):  # Add your TileMap group here
			queue_free()
