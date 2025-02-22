extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 980.0
const TOTHP = 100

@onready var animSpr: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player
@onready var bodyColl: CollisionShape2D = $BodyColl
@onready var gun: Node2D = $enemyGun
@onready var game_manager: Node2D = %GameManager
@onready var shoulder_position_left: Marker2D = $ShoulderPositionLeft
@onready var shoulder_position_right: Marker2D = $ShoulderPositionRight
@onready var stoprc: RayCast2D = $StopRC
@onready var gunColl: CollisionShape2D = $CollisionShape2D

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

	# Gravity effect
	if not is_on_floor():
		velocity.y += GRAVITY * delta 

	# RayCast check for movement
	stoprc.rotation = 0
	stoprc.target_position = (player.global_position - stoprc.global_position).normalized() * 70
	var collider = stoprc.get_collider()
	movable = collider == null or not collider.is_in_group("player")

	movementAI()
	GunOrient()
	move_and_slide()

func GunOrient():
	var is_facing_left = player.global_position.x < global_position.x
	if is_facing_left:
		gun.position = shoulder_position_right.position
	else:
		gun.position = shoulder_position_left.position

func movementAI():
	if is_reloading:
		return

	if not movable:
		velocity.x = 0
		if animSpr.animation != "idle":
			animSpr.play("idle")  # Prevents animation interruption
		return
	
	var direction = (player.global_position - global_position).normalized()
	if direction.x > 0 and last_direction != 1:
		animSpr.flip_h = false
		last_direction = 1
	elif direction.x < 0 and last_direction != -1:
		animSpr.flip_h = true
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
	set_meta("hp", get_meta("hp") - 50)

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
	print("Reloading...")
	gun.visible = false
	animSpr.speed_scale = 0.1
	animSpr.play("reload")
	animSpr.speed_scale = 1
	print("Reload complete!")
	var reload_time = 1
	get_tree().create_timer(reload_time).timeout.connect(_on_reload_complete)

func _on_reload_complete():
	gun.visible = true
	gun.mag = gun.MAGAZINETOTAL
	is_reloading=false
	gun.reloading = false 
