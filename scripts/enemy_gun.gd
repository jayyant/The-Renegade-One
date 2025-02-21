extends Node2D

@export var fireRateInterval: float = 1.0  # Fire rate per enemy
@export var despawnTime: float = 1.0  # Bullet lifespan

var bulletPath = preload("res://scenes/enemyBullet.tscn")
var canFire: bool = true

@onready var shootPos: Node2D = $Position
@onready var player: CharacterBody2D = $"../../Player"
@onready var enemy: CharacterBody2D = $".."
@onready var rc2: RayCast2D = enemy.find_child("RayCast2D")  # Cached RayCast2D

func _process(_delta: float) -> void:
	if not enemy.get_meta("isdead"):
		gunOrient()

func gunOrient():
	look_at(player.position)
	scale.y = -4 if cos(rotation) < 0 else 4
	rc2.rotation = rotation + PI

	if canFire and rc2.is_colliding():
		var collider = rc2.get_collider()
		if collider and collider.is_in_group("shootable"):
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(global_position, collider.global_position)
			var result = space_state.intersect_ray(query)

			if result and result.collider == collider:
				fire()

func fire():
	canFire = false

	var bullet = bulletPath.instantiate()
	bullet.global_position = shootPos.global_position
	bullet.direction = rotation

	if player and is_instance_valid(player) and player.has_method("_on_bullet_hit"):
		bullet.bullethitEnemy.connect(player._on_bullet_hit)

	get_tree().current_scene.add_child(bullet)
	bullet.add_to_group("bullets")

	get_tree().create_timer(despawnTime).timeout.connect(func():
		if is_instance_valid(bullet):
			bullet.queue_free()
	)

	get_tree().create_timer(fireRateInterval).timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	canFire = true
