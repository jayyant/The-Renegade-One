extends CharacterBody2D

@onready var shootPos: Node2D = $Position
@onready var camera: Camera2D = %Camera2D
var bulletPath=preload("res://scenes/Bullet.tscn")
var fireRateInterval:float=0.1
var canFire:bool=true

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("shoot") and canFire:
		fire()

func fire():
	canFire=false
	get_tree().create_timer(fireRateInterval).timeout.connect(_on_timer_timeout)
	var bullet=bulletPath.instantiate()
	bullet.direction=rotation
	bullet.pos=shootPos.global_position
	bullet.rot=global_rotation
	get_parent().add_child(bullet)
	despawn(bullet)
	
func despawn(bullet):
	var camRect=camera.get_viewport_rect()
	print(camRect)
	camRect = Rect2(camera.global_transform.origin + camRect.position, camRect.size)
	print(camRect)
	print(bullet.global_position)
	if camRect.has_point(bullet.global_position):
		bullet.queue_free()
		print("E")

func _on_timer_timeout():
	canFire=true
