extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 980.0
const TOTHP = 100

@onready var animSpr: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player
@onready var bodyColl: CollisionShape2D = $BodyColl
@onready var enemy_gun: Node2D = $enemyGun

var last_direction = 1  # 1 = Right, -1 = Left

func _ready():
	set_meta("isdead", false)
	set_meta("hp", TOTHP)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta 
	
	if get_meta("isdead"):
		set_physics_process(false)
	else:
		movementAI()

func movementAI():
	var direction = (player.global_position - global_position).normalized()

	# Flip sprite when changing direction
	if direction.x > 0 and last_direction != 1:
		animSpr.flip_h = false
		last_direction = 1
	elif direction.x < 0 and last_direction != -1:
		animSpr.flip_h = true
		last_direction = -1

	# Play movement animation
	if abs(direction.x) > 0.1:
		animSpr.play("run")
	elif velocity.x==0:
		animSpr.play("idle")

	velocity.x = direction.x * SPEED
	move_and_slide()

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
