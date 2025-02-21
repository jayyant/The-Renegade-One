extends Node2D

@export var fireRateInterval: float = 1.0  # Fire rate per enemy
@export var despawnTime: float = 1.0  # Bullet lifespan

@onready var shootPos: Node2D = $Position
@onready var player: CharacterBody2D = $"../../Player"
@onready var enemy: CharacterBody2D = $".."
@onready var rc2: RayCast2D = enemy.find_child("RayCast2D")
@onready var shoulder_position_left: Marker2D = enemy.get_node("ShoulderPositionLeft")
@onready var shoulder_position_right: Marker2D = enemy.get_node("ShoulderPositionRight")
@onready var shoulder_position_idle: Marker2D = enemy.get_node("ShoulderPositionIdle")

var bulletPath = preload("res://scenes/enemyBullet.tscn")
var canFire: bool = true
var gunScale = scale.y

func _process(_delta: float) -> void:
	if not enemy.get_meta("isdead"):
		gunOrient()

func gunOrient():
	look_at(player.global_position)
	var is_facing_left = player.global_position.x < global_position.x
	scale.y = -gunScale if is_facing_left else gunScale

	rc2.rotation = 0 
	rc2.target_position = (player.global_position - rc2.global_position).normalized() * 100 

	if canFire and rc2.is_colliding():
		var collider = rc2.get_collider()
		if collider and collider.is_in_group("player"):
			fire()

func fire():
	canFire = false

	var bullet = bulletPath.instantiate()
	bullet.global_position = shootPos.global_position
	bullet.rotation = rotation  # Ensure proper direction
	bullet.direction = rotation  # Assigns the angle directly

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
