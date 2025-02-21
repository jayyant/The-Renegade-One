extends CharacterBody2D

signal interaction

@export var SPEED = 200.0
@onready var interaction_prompt: Control = $InteractionPrompt
@onready var interaction_menu: CanvasLayer = $InteractionMenu
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var lastdir : Array = [1]
var finaldir

func _ready() -> void:
	interaction_prompt.hide()


func _physics_process(delta: float) -> void:

	var direction = Input.get_vector("moveLeft","moveRight","moveUp","moveDown")
	finaldir = savedir(direction.x)
	if direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false
	else:
		if finaldir > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
		
	if direction:
		animated_sprite.play("walk")
		velocity.x = move_toward(velocity.x,direction.x*SPEED,40)
		velocity.y = move_toward(velocity.y,direction.y*SPEED,40)
	else:
		animated_sprite.play("idle")
		velocity = Vector2(0,0)
	interact()
	move_and_slide()
	

func savedir(dir):
	if dir == 0:
		return lastdir[0]
	else:
		lastdir.append(dir)
		lastdir.remove_at(0)
		return

func interact():
	if Input.is_action_just_pressed("Interact"):
		emit_signal("interaction")
		interaction_prompt.hide()
		animated_sprite.play("idle")

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
