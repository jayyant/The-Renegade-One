extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var point_light: PointLight2D = $"../../NPC/PointLight2D"

func _ready() -> void:
	sprite.hide()
	point_light.hide()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprite.show()
		point_light.show()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprite.hide()
		point_light.hide()
