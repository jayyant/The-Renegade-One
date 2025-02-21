extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Node2D/Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var bufferTimer: Timer = $bufferTimer
@onready var coyoteTimer: Timer = $coyoteTimer
@onready var camera: Camera2D = $Camera2D
@onready var node_2d: Node2D = $Node2D
@onready var zoomTween:Tween = get_tree().create_tween()

const TARGETSPEED = 600.0
const JUMP_VELOCITY = 800.0
const SPEED = 200.0
const GRAVITY = 980
const AIR_CONTROL = 0.8
const TOTHP=100

var jumpBuffer:bool = false
var coyoteTime:bool = false
var hp=TOTHP

func _ready() -> void:
	bufferTimer.timeout.connect(jumpBufferTimeout)
	coyoteTimer.timeout.connect(coyoteTimeout)

func _physics_process(delta: float) -> void:
	move_and_slide()
	apply_gravity()
	jump()
	move()

func apply_gravity():
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, GRAVITY, 40)

func jump():
	if is_on_floor():
		if Input.is_action_just_pressed("jump") or jumpBuffer:
			velocity.y = -JUMP_VELOCITY
			jumpBuffer = false
	else:
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= 0.5
		if Input.is_action_just_pressed("jump"):
			jumpBuffer = true
			bufferTimer.start()

func move():
	var direction = Input.get_axis("moveLeft", "moveRight")
	if is_on_floor():
		velocity.x = move_toward(velocity.x, direction * TARGETSPEED if direction else 0, 60)
	else:
		velocity.x = move_toward(velocity.x, direction * TARGETSPEED if direction else 0, 20)

func jumpBufferTimeout():
	jumpBuffer = false

func coyoteTimeout():
	coyoteTime = false

func _on_bullet_hit():
	print("Player hit!")
	hp -= 50
	if hp <= 0:
		print("Dead")
		hp+=100
