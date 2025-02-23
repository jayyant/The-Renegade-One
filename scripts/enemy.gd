extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 980.0
const TOTHP = 150

@onready var animSpr: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player
@onready var bodyColl: CollisionShape2D = $BodyColl
@onready var gun: Node2D = $enemyGun
@onready var game_manager: Node2D = %GameManager
@onready var shoulder_position_left: Marker2D = $ShoulderPositionLeft
@onready var shoulder_position_right: Marker2D = $ShoulderPositionRight
@onready var stoprc: RayCast2D = $StopRC
@onready var gunColl: CollisionShape2D = $GunCollission
@onready var shootrc: RayCast2D = $RayCast2D

var movable: bool = true
var last_direction = 1
var is_reloading: bool = false

func _ready():
	set_meta("isdead", false)
	set_meta("hp", TOTHP)
	gun.reload.connect(_on_reload)  # Ensure reload signal is connected
	animSpr.play("idle")  # Ensure idle animation plays on start

func _physics_process(delta: float) -> void:
	if get_meta("isdead"):
		set_physics_process(false)
		return

	var direction = (player.global_position - global_position).normalized()	
	var is_facing_left = player.global_position.x < global_position.x

	# Gravity effect
	if not is_on_floor():
		velocity.y += GRAVITY * delta 

	# RayCast check for movement
	var collider = stoprc.get_collider()
	movable = collider == null or not collider.is_in_group("player")

	movementAI(direction,is_facing_left)
	GunOrient()
	move_and_slide()

func GunOrient():
	# Calculate the direction to the player
	var direction_to_player = player.global_position - gun.global_position
	var angle_to_player = direction_to_player.angle()

	# Set gun rotation to face player
	gun.rotation = angle_to_player

	# Align RayCasts with the gun's position and apply rotation
	shootrc.global_position = gun.global_position + direction_to_player.normalized()  # Small offset from the gun's center
	stoprc.global_position = gun.global_position + direction_to_player.normalized()

	# Smoothly rotate both RayCasts toward the gun's angle using lerp_angle
	shootrc.rotation = lerp_angle(shootrc.rotation, gun.rotation, 0.5)
	stoprc.rotation = lerp_angle(stoprc.rotation, gun.rotation, 0.7)



func movementAI(direction,is_facing_left):
	if is_reloading:
		return
	
	if is_facing_left:
		animSpr.flip_h = true
	else:
		animSpr.flip_h = false

	if not movable:
		velocity.x = 0
		if animSpr.animation != "idle":
			animSpr.play("idle")
		return
	
	if direction.x > 0 and last_direction != 1:
		last_direction = 1
	elif direction.x < 0 and last_direction != -1:
		last_direction = -1

	# Prevent walking into walls
	if is_on_wall():
		velocity.x = 0
	
	# Play animation based on movement
	if velocity.x != 0:
		if animSpr.animation != "run":
			animSpr.play("run")  # Ensures smooth animation transition
	else:
		if animSpr.animation != "idle":
			animSpr.play("idle")

	velocity.x = direction.x * SPEED

func _on_bullet_hit():
	if get_meta("isdead"):
		return

	print(name, " hit! Current HP:", get_meta("hp"))
	set_meta("hp", get_meta("hp") - 10)

	if get_meta("hp") <= 0:
		die()

func die():
	print(name, " Dead!")
	set_meta("isdead", true)
	animSpr.play("death")
	gun.visible = false
	velocity = Vector2.ZERO  
	bodyColl.set_deferred("disabled", true)
	gunColl.set_deferred("disabled", true)
	game_manager.enemyKilled() 

func _on_reload() -> void:
	is_reloading=true
	gun.visible = false
	animSpr.play("reload")
	var reload_time = 1
	get_tree().create_timer(reload_time).timeout.connect(_on_reload_complete)

func _on_reload_complete():
	gun.visible = true
	gun.mag = gun.MAGAZINETOTAL
	is_reloading=false
	gun.reloading = false 
