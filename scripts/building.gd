extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enter_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hide()



func _on_enter_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		show()
