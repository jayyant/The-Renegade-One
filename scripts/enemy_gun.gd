extends Node2D

const MAGAZINETOTAL = 6

@export var fireRateInterval: float = 1.0
@export var despawnTime: float = 1.0

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
var mag = MAGAZINETOTAL
var reloading = false

signal reload

func _process(_delta: float) -> void:
	if not enemy.get_meta("isdead"):
		gunOrient()

func gunOrient():
	# Calculate the direction to the player
	var direction = player.global_position - global_position
	var angle_to_player = direction.angle()

	# Set gun rotation to face player
	rotation = angle_to_player

	# Position and rotate RayCast to align with gun
	rc2.global_position = shootPos.global_position  # Ensure RayCast starts at the correct position
	rc2.rotation = rotation  # Rotate RayCast to match gun rotation

	# Flip sprite scale so the gun is held properly in both directions
	var is_facing_left = player.global_position.x < global_position.x
	scale.y = -gunScale if is_facing_left else gunScale
	
	if is_facing_left:
		position = shoulder_position_right.position  # Move to the left shoulder
	else:
		position = shoulder_position_left.position  # Move to the right shoulder
	
	# Shooting logic
	if canFire and rc2.is_colliding():
		var collider = rc2.get_collider()
		if collider and collider.is_in_group("player"):
			if mag > 0:
				fire()
			elif not reloading:
				reloading = true
				emit_signal("reload")

func fire():
	mag -= 1
	canFire = false

	var bullet = bulletPath.instantiate()
	bullet.global_position = shootPos.global_position
	bullet.rotation = rotation
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
