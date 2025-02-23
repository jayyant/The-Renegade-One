extends CharacterBody2D

signal bullethitEnemy(collider)

var speed: float = 1000.0
var direction: float = 0.0  
@export var bullet_spread: float = 0.05

func _ready():
	var spread_angle = randf_range(-bullet_spread, bullet_spread)
	direction += spread_angle  

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed, 0).rotated(direction)

	var collision = move_and_collide(velocity * delta)

	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("player"):
			bullethitEnemy.emit()
			queue_free()
		elif collider.is_in_group("tilemap"):
			queue_free()
		elif collider.is_in_group("shootable"):
			bullethitEnemy.emit()
			queue_free()
