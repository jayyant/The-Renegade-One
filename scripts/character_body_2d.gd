extends CharacterBody2D

signal interaction

@export var SPEED = 200.0
@onready var interaction_prompt: Control = $InteractionPrompt
@onready var interaction_menu: CanvasLayer = $InteractionMenu



func _ready() -> void:
	interaction_prompt.hide()


func _physics_process(delta: float) -> void:

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
		interaction_prompt.hide()

func _on_npc_near() -> void:
	interaction_prompt.show()


func _on_npc_notnear() -> void:
	interaction_prompt.hide()


func _on_leave_pressed() -> void:
	set_physics_process(true)
	interaction_menu.hide()


func _on_door_neardoor() -> void:
	interaction_prompt.show()


func _on_door_notneardoor() -> void:
	interaction_prompt.hide()
