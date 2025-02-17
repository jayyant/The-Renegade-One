extends CharacterBody2D

signal interaction

@export var SPEED = 200.0


func _ready() -> void:
	pass
	


func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("moveLeft","moveRight","moveUp","moveDown")
	#if direction.y < 0:
		#animated_sprite.flip_h = false
	#else:
		#animated_sprite.flip_h = true
	if direction:
		velocity.x = move_toward(velocity.x,direction.x*SPEED,40)
		velocity.y = move_toward(velocity.y,direction.y*SPEED,40)
	else:
		velocity = Vector2(0,0)
	#animate()
	interact()
	move_and_slide()
	
	
#func animate():
	#if velocity != Vector2(0,0):
		#animated_sprite.play("run")
	#else:
		#animated_sprite.play("idle")

func interact():
	if Input.is_action_just_pressed("Interact"):
		emit_signal("interaction")
