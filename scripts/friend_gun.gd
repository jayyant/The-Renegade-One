extends Node2D

const MAGAZINETOTAL = 6

@export var fireRateInterval: float = 1.0
@export var despawnTime: float = 1.0

@onready var shootPos: Node2D = $Position
@onready var enemy: CharacterBody2D = $".."
@onready var rc2: RayCast2D = enemy.find_child("RayCast2D")
@onready var shoulder_position_left: Marker2D = enemy.get_node("ShoulderPositionLeft")
@onready var shoulder_position_right: Marker2D = enemy.get_node("ShoulderPositionRight")

var bulletPath = preload("res://scenes/enemyBullet.tscn")
var canFire: bool = true
var gunScale = scale.y
var mag = MAGAZINETOTAL
var reloading = false
var target_enemy: CharacterBody2D = null

signal reload

func _process(_delta: float) -> void:
	if enemy.get_meta("isdead"):
		return

	if not target_enemy or target_enemy.get_meta("isdead"):
		target_enemy = enemy.find_closest_enemy() 

	gunOrient()

func gunOrient():
	if not target_enemy:
		return
	
	var direction = target_enemy.global_position - global_position
	var angle_to_target = direction.angle()

	rotation = angle_to_target  

	rc2.global_position = shootPos.global_position
	rc2.rotation = rotation

	var is_facing_left = target_enemy.global_position.x < global_position.x
	scale.y = -gunScale if is_facing_left else gunScale
	
	position = shoulder_position_right.position if is_facing_left else shoulder_position_left.position

	if canFire and rc2.is_colliding():
		var collider = rc2.get_collider()
		if collider and collider.is_in_group("enemy"):
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
	bullet.direction = rotation  

	if target_enemy and is_instance_valid(target_enemy) and target_enemy.has_method("_on_bullet_hit"):
		bullet.bullethitEnemy.connect(target_enemy._on_bullet_hit)

	get_tree().current_scene.add_child(bullet)
	bullet.add_to_group("bullets")

	get_tree().create_timer(despawnTime).timeout.connect(func():
		if is_instance_valid(bullet):
			bullet.queue_free()
	)

	get_tree().create_timer(fireRateInterval).timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	canFire = true
