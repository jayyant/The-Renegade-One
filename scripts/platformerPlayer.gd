extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var bufferTimer: Timer = $bufferTimer
@onready var coyoteTimer: Timer = $coyoteTimer
@onready var rayRight: RayCast2D = $RayCastRight
@onready var rayLeft: RayCast2D = $RayCastLeft
@onready var rayDown: RayCast2D = $RayCastDown
@onready var camera: Camera2D = $Camera2D
@onready var node_2d: Node2D = $Node2D
@onready var staminaBar: TextureProgressBar = $"../CanvasLayer/Control/StaminaProgressBar"
@onready var staminaTimer: Timer = $staminaTimer
@onready var player=get_tree().get_current_scene()
@onready var projectile=load("res://Scenes&Scripts/Shuriken.tscn")
@export var projspeed = 350
@onready var timer: Timer = $Timer
var a = []

const TARGETSPEED = 600.0
const SPRINTSPEED = 900.0
const JUMP_VELOCITY = 800.0
const GRAVITY:int = 980
const SPEED = 200.0
const WALL_SLIDE = 200
const MAX_STAMINA = 200

var jumpBuffer:bool=false
var coyoteTime:bool=false
var wallCollission:bool=false
var stamina:int
@onready var zoomTween:Tween=get_tree().create_tween()

func _ready() -> void:
	bufferTimer.timeout.connect(jumpBufferTimeout)
	coyoteTimer.timeout.connect(coyoteTimeout)
	staminaTimer.timeout.connect(staminaUpdater)
	stamina=MAX_STAMINA
	staminaTimer.start()

func _process(delta: float) -> void:
	var direction = 1
	var finaldir
	#if Input.is_action_just_pressed("shoot"):
		#direction=Input.get_axis("leftMove", "rightMove")
		#finaldir = direction
		#if direction != 0:
			#a.remove_at(0)
			#a.append(direction)
		#elif direction == 0 and a[0] != null:
			#finaldir = a[0]
		#print(finaldir)
		#shooter(finaldir)

func _physics_process(delta: float) -> void:
	move_and_slide()
	if not is_on_floor(): #Gravity
		if velocity.y>0:
			velocity.y=move_toward(velocity.y,GRAVITY,40)
		else:
			velocity.y=move_toward(velocity.y,GRAVITY,20)
	jump(delta)
	move(delta)

func jump(delta):
	match is_on_floor():
		true:
			if Input.is_action_just_pressed("jump") or jumpBuffer:
				velocity.y=-move_toward(400,JUMP_VELOCITY,150)
				jumpBuffer=false
		false:
			if Input.is_action_just_released("jump") and velocity.y < 0:
				velocity.y*=0.5
			if Input.is_action_just_pressed("jump"):
				jumpBuffer=true
				bufferTimer.start()
			#wallJump()

func move(delta):
	var direction := Input.get_axis("leftMove", "rightMove")
	if direction:
		match is_on_floor():
			true:
				node_2d.skew=0.4*(velocity.x/SPRINTSPEED)
				velocity.x = move_toward(velocity.x,direction*TARGETSPEED,60)
			false:
				node_2d.skew=0.4*(velocity.x/SPRINTSPEED)
				velocity.x = move_toward(velocity.x,direction*TARGETSPEED,50)
	else:
		node_2d.skew=move_toward(node_2d.skew,0,0.1)
		velocity.x = move_toward(velocity.x, 0, 60)
	
	#sprint(direction,delta)

#func wallJump():
	#if rayRight.is_colliding()  and velocity.y>0:
		#if Input.is_action_pressed("jump"):
			#velocity.y=0
		#if Input.is_action_just_pressed("leftMove") and not Input.is_action_just_pressed("rightMove"):
			#velocity=Vector2(-500,-500)
	#if rayLeft.is_colliding() and Input.is_action_pressed("jump")  and velocity.y>0:
		#if Input.is_action_pressed("jump"):
			#velocity.y=0
		#if Input.is_action_just_pressed("rightMove") and not Input.is_action_just_pressed("leftMove"):
			#velocity+=Vector2(500,-500)


#func sprint(dir,delta):
	#if is_on_floor():
		#if Input.is_action_pressed("sprint") and stamina>0 and dir:
			#velocity.x = move_toward(velocity.x, dir*SPRINTSPEED, 100)
			#camera.zoom=camera.zoom.lerp(Vector2(1.4,1.4),40*delta)
		#if Input.is_action_just_released("sprint") or stamina==0:
			#velocity.x = move_toward(velocity.x, dir*TARGETSPEED, 100)
			#camera.zoom=Vector2(1.25,1.25)
			#camera.zoom=camera.zoom.lerp(Vector2(1.25,1.25),40*delta)

func jumpBufferTimeout():
	jumpBuffer=false

func coyoteTimeout():
	coyoteTime=false

func staminaUpdater():
	if Input.is_action_pressed("sprint") and is_on_floor() and velocity.x != 0:
		stamina-=5
	if velocity.x>-TARGETSPEED or velocity.x<=TARGETSPEED:
		stamina+=1
	
	stamina = clamp(stamina, 0, MAX_STAMINA)
#
#func shooter(direction):
	#var i=projectile.instantiate()
	#i.dir=rotation*direction
	#i.spawnPos=global_position
	#i.spawnRot=global_rotation
	#i.velocity = Vector2(direction*projspeed,0)
	#player.add_child.call_deferred(i)
	#get_tree().create_timer(3).timeout.connect(i.queue_free)
	#timer.start()
	


#func on_timer_timeout():
	#i.queue_free()
