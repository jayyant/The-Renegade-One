extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 980.0
const TOTHP = 100

@onready var player: CharacterBody2D = %Player
@onready var bodyColl: CollisionShape2D = $BodyColl
@onready var enemy_gun: Node2D = $enemyGun

func _ready():
	set_meta("isdead", false)
	set_meta("hp", TOTHP)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta 
	if not get_meta("isdead"):
		movementAI()
	else:
		set_physics_process(false)

func movementAI():
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * SPEED
	move_and_slide()

func _on_bullet_hit():
	if get_meta("isdead"):  # Prevent extra hits after death
		return

	print(name, " hit! Current HP:", get_meta("hp"))
	set_meta("hp", get_meta("hp") - 50)
	
	if get_meta("hp") <= 0:
		print(name, " Dead!")
		set_meta("isdead", true)
