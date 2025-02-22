extends CharacterBody2D


const SPEED = 150.0
const GRAVITY = 980.0
const TOTHP = 100



@onready var animSpr: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player
@onready var bodyColl: CollisionShape2D = $BodyColl
@onready var enemy_gun: Node2D = $enemyGun
@onready var game_manager: Node2D = %GameManager
@onready var shoulder_position_left: Marker2D = $ShoulderPositionLeft
@onready var shoulder_position_right: Marker2D = $ShoulderPositionRight
@onready var stoprc: RayCast2D = $StopRC
var movable:bool=true

var last_direction = 1

func _ready():
	set_meta("isdead", false)
	set_meta("hp", TOTHP)

func _physics_process(delta: float) -> void:
	stoprc.rotation = 0 

	stoprc.target_position = (player.global_position - stoprc.global_position).normalized() * 70 
	if not is_on_floor():
		velocity.y += GRAVITY * delta 

	if get_meta("isdead"):
		set_physics_process(false)
		return

	var collider = stoprc.get_collider()
	movable = collider == null or not collider.is_in_group("player")

	movementAI()
	
	GunOrient()
	move_and_slide()


func GunOrient():
	var is_facing_left = player.global_position.x < global_position.x
	if is_facing_left:
		enemy_gun.position = shoulder_position_right.position
	else:
		enemy_gun.position = shoulder_position_left.position
func movementAI():
	if not movable:
		velocity.x = 0  # Override movement immediately if not movable
		animSpr.play("idle")
		return  # Stop function execution
	var direction = (player.global_position - global_position).normalized()
	if direction.x > 0 and last_direction != 1:
		animSpr.flip_h = false
		last_direction = 1
	elif direction.x < 0 and last_direction != -1:
		animSpr.flip_h = true
		last_direction = -1


	print("Movable:", movable, "Velocity:", velocity.x)
	
	if is_on_wall():
		velocity.x = 0  
	
	if velocity.x != 0:
		animSpr.play("run")
	else:
		animSpr.play("idle")
	
	velocity.x = direction.x * SPEED  # Only update velocity if movable is true

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
	enemy_gun.visible=false
	await animSpr.animation_finished  
	velocity = Vector2.ZERO  
	bodyColl.set_deferred("disabled", true)
	game_manager.enemyKilled() 

func setplayer(plr : CharacterBody2D):
	return plr
