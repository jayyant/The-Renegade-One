extends CharacterBody2D

var pos:Vector2
var rot:float
var direction:float
var speed=1000

func _ready() -> void:
	global_position=pos
	global_rotation=rot

func _physics_process(delta: float) -> void:
	velocity=Vector2(speed,0).rotated(direction)
	move_and_slide()
