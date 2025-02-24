extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var bufferTimer: Timer = $bufferTimer
@onready var coyoteTimer: Timer = $coyoteTimer
@onready var camera: Camera2D = $Camera2D
@onready var animSpr: AnimatedSprite2D = $AnimatedSprite2D
@onready var deathscreen: Control = $CanvasLayer/Control
@onready var gun: Node2D = $Node2D/Gun
@onready var ui: CanvasLayer = $"../UI"

const TARGETSPEED = 350.0
const JUMP_VELOCITY = 800.0
const SPEED = 200.0
const GRAVITY = 980
const AIR_CONTROL = 0.8
const TOTHP=100

var jumpBuffer:bool = false
var coyoteTime:bool = false
var hp=TOTHP
var reloading=false

func _ready() -> void:
	ui.visible=true
	bufferTimer.timeout.connect(jumpBufferTimeout)
	coyoteTimer.timeout.connect(coyoteTimeout)
	gun.connect("reloadgun", Callable(self, "_on_gun_reload"))
	print("Reloadgun signal connected:", gun.has_signal("reloadgun"))

func _physics_process(_delta: float) -> void:
	if not reloading:
		move()
	else:
		velocity.x=0

	move_and_slide()  # Move the character normally when not reloading
	apply_gravity()
	jump()



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
	if reloading:
		# Skip all movement logic and animation logic during reload
		return  # Early exit if reloading

	var direction = Input.get_axis("leftMove", "rightMove")
	var is_gun_facing_left = get_node("Node2D/Gun").scale.y < 0

	if direction:
		if (direction < 0 and not is_gun_facing_left) or (direction > 0 and is_gun_facing_left):
			animSpr.play("run", -1, -1)
		else:
			animSpr.play("run")
	elif not animSpr.is_playing() or animSpr.animation != "reload":
		animSpr.play("idle")

	if is_on_floor():
		velocity.x = move_toward(velocity.x, float(direction * TARGETSPEED) if direction else 0.0, 60)
	else:
		velocity.x = move_toward(velocity.x, float(direction * TARGETSPEED) if direction else 0.0, 20)



func jumpBufferTimeout():
	jumpBuffer = false

func coyoteTimeout():
	coyoteTime = false

func _on_gun_reload():
	reloading=true
	animSpr.play("reload")
	get_tree().create_timer(1.0).timeout.connect(_on_reload)

func _on_reload():
	reloading=false

func _on_bullet_hit():
	if hp!=0:
		hp -= 10
	if hp <= 0:
		ui.visible=false
		print("Dead")
		animSpr.play("dead")
		deathscreen.show()
		set_physics_process(false)
<<<<<<< HEAD


func _on_fall_death_death() -> void:
	animSpr.play("dead")
	deathscreen.show()
	set_physics_process(false)
=======
>>>>>>> eb2ea85023fc6bb1a578b945c20dd3daad267f17
