extends Area2D

@onready var texture_rect: TextureRect = $Sprite2D/CanvasLayer/TextureRect
@onready var pagetext: Label = $Sprite2D/CanvasLayer/Pagetext

func _ready() -> void:
	texture_rect.hide()
	pagetext.hide()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		texture_rect.show()
		pagetext.show()
		


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		texture_rect.hide()
		pagetext.hide()
