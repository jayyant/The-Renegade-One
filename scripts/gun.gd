extends Node2D

@onready var shoulder_position_left: Marker2D = $"../../ShoulderPositionLeft"
@onready var shoulder_position_right: Marker2D = $"../../ShoulderPositionRight"
@onready var shoulder_position_run: Marker2D = $"../../ShoulderPositionRun"

@onready var player: CharacterBody2D = %Player
@onready var shootPos: Node2D = $Position
@onready var camera: Camera2D = %Camera2D
@onready var pivot: Node2D = $".."
var bulletPath = preload("res://scenes/Bullet.tscn")

var fireRateInterval: float = 0.2
var canFire: bool = true
var despawnTime = 1
var gunScale = scale.y

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	# Get the pivot point (parent Node2D)
	var is_facing_left = get_global_mouse_position().x < pivot.global_position.x
	scale.y = -gunScale if is_facing_left else gunScale

	player.get_node("AnimatedSprite2D").flip_h = is_facing_left
	if player.velocity.x!=0:
		pivot.position = shoulder_position_run.position
	elif is_facing_left:
		pivot.position = shoulder_position_right.position
	else:
		pivot.position = shoulder_position_left.position

	if Input.is_action_pressed("shoot") and canFire:
		fire()


func fire():
	canFire = false
	
	# Apply recoil based on rotation
	if player.is_on_floor():
		player.velocity.x += -500 * cos(rotation)
	else:
		player.velocity.y = -400 * sin(rotation)

	# Instantiate bullet
	var bullet = bulletPath.instantiate()
	bullet.global_position = shootPos.global_position  
	bullet.rotation = rotation
	bullet.direction = rotation

	# Connect bullet's signal so it affects the correct enemy on hit
	bullet.bullethitEnemy.connect(_on_bullet_hit_enemy)

	# Add bullet to scene
	get_tree().get_root().add_child(bullet)

	# Despawn bullet after a set time
	get_tree().create_timer(despawnTime).timeout.connect(func():
		if is_instance_valid(bullet):
			bullet.queue_free()
	)

	# Fire rate timer
	get_tree().create_timer(fireRateInterval).timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	canFire = true

func _on_bullet_hit_enemy(enemy):
	if enemy and enemy.has_method("_on_bullet_hit"):
		enemy._on_bullet_hit()
