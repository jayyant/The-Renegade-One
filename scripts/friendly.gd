extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 980.0
const TOTHP = 100

@onready var animSpr: AnimatedSprite2D = $AnimatedSprite2D
@onready var bodyColl: CollisionShape2D = $BodyColl
@onready var gun: Node2D = $friendGun
@onready var game_manager: Node2D = %GameManager
@onready var shoulder_position_left: Marker2D = $ShoulderPositionLeft
@onready var shoulder_position_right: Marker2D = $ShoulderPositionRight
@onready var stoprc: RayCast2D = $StopRC
@onready var gunColl: CollisionShape2D = $GunCollission
@onready var shootrc: RayCast2D = $RayCast2D

var target_enemy: CharacterBody2D = null
var movable: bool = true
var last_direction = 1
var is_reloading: bool = false

func _ready():
	set_meta("isdead", false)
	set_meta("hp", TOTHP)
	gun.reload.connect(_on_reload)  
	animSpr.play("idle")

func _physics_process(delta: float) -> void:
	if get_meta("isdead"):
		set_physics_process(false)
		return

	# Find a target enemy if none is set or if the current one is dead
	if not target_enemy or target_enemy.get_meta("isdead"):
		target_enemy = find_closest_enemy()

	if target_enemy:
		var direction = (target_enemy.global_position - global_position).normalized()
		var is_facing_left = target_enemy.global_position.x < global_position.x

		if not is_on_floor():
			velocity.y += GRAVITY * delta 

		var collider = stoprc.get_collider()
		movable = collider == null or not collider.is_in_group("enemy")

		movementAI(direction, is_facing_left)
		GunOrient()
		move_and_slide()

func find_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest_enemy = null
	var closest_distance = INF

	for enemy in enemies:
		if enemy.get_meta("isdead"):
			continue  

		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

	return closest_enemy

func GunOrient():
	if target_enemy:
		var direction_to_target = target_enemy.global_position - gun.global_position
		var angle_to_target = direction_to_target.angle()

		gun.rotation = angle_to_target

		shootrc.global_position = gun.global_position + direction_to_target.normalized()
		stoprc.global_position = gun.global_position + direction_to_target.normalized()

		shootrc.rotation = lerp_angle(shootrc.rotation, gun.rotation, 0.5)
		stoprc.rotation = lerp_angle(stoprc.rotation, gun.rotation, 0.7)

func movementAI(direction, is_facing_left):
	if is_reloading:
		return

	animSpr.flip_h = is_facing_left

	if not movable:
		velocity.x = 0
		animSpr.play("idle")
		return

	last_direction = 1 if direction.x > 0 else -1 if direction.x < 0 else last_direction

	if is_on_wall():
		velocity.x = 0

	animSpr.play("run" if velocity.x != 0 else "idle")

	velocity.x = direction.x * SPEED

func _on_bullet_hit():
	if get_meta("isdead"):
		return

	set_meta("hp", get_meta("hp") - 50)
	if get_meta("hp") <= 0:
		die()

func die():
	set_meta("isdead", true)
	animSpr.play("death")
	gun.visible = false
	velocity = Vector2.ZERO  
	bodyColl.set_deferred("disabled", true)
	gunColl.set_deferred("disabled", true)
	game_manager.friendlyKilled()

func _on_reload():
	is_reloading = true
	gun.visible = false
	animSpr.play("reload")
	get_tree().create_timer(1.0).timeout.connect(_on_reload_complete)

func _on_reload_complete():
	gun.visible = true
	gun.mag = gun.MAGAZINETOTAL
	is_reloading = false
	gun.reloading = false
