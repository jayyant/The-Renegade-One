extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 980.0
const TOTHP = 100

signal killed
var isded=false

@onready var game_manager: Node2D = %GameManager
@onready var player: CharacterBody2D = $"../Player"
@onready var bodyColl: CollisionShape2D = $BodyColl
var hp = TOTHP

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta 
	if not isded:
		movementAI()
	else:
		bodyColl.disabled=true

func movementAI():
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * SPEED
	move_and_slide()

func _on_bullet_hit():
	print("Enemy hit!")
	hp -= 50
	if hp <= 0:
		print("Enemy Dead")
		killed.emit()
		isded=true
