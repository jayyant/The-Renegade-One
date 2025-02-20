extends Node2D

@onready var player: CharacterBody2D = $".."
@onready var shootPos: Node2D = $Position
@onready var camera: Camera2D = %Camera2D
@onready var enemy: CharacterBody2D = $"../../Enemy"
var bulletPath = preload("res://scenes/Bullet.tscn")

var fireRateInterval: float = 0.2
var canFire: bool = true
var despawnTime = 1

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	scale.y = -1 if cos(rotation) < 0 else 1

	if Input.is_action_pressed("shoot") and canFire:
		fire()

func fire():
	canFire = false
	
	if player.is_on_floor():
		player.velocity.x += -500 * cos(rotation)
	else:
		player.velocity.y=-400 * sin(rotation)

	var bullet = bulletPath.instantiate()
	bullet.global_position = shootPos.global_position  
	bullet.rotation = rotation
	bullet.direction = rotation
	if not enemy.isded:
		bullet.bullethitEnemy.connect(enemy._on_bullet_hit)

	get_parent().get_parent().add_child(bullet)

	get_tree().create_timer(despawnTime).timeout.connect(func():
		if is_instance_valid(bullet):
			bullet.queue_free()
	)

	get_tree().create_timer(fireRateInterval).timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	canFire = true
