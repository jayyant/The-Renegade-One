extends CharacterBody2D 

signal bullethitEnemy(enemy)  # Signal now passes the enemy that got hit

var speed: float = 1000.0
var direction: float = 0.0  

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(Vector2(speed, 0).rotated(direction) * delta)

	if collision:
		var collider = collision.get_collider()
		if collider and collider.is_in_group("shootable"):
			bullethitEnemy.emit(collider)  # Emit the enemy instance
			queue_free()
		elif collider and collider.is_in_group("tilemap"):  
			queue_free()
