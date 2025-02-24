extends AnimatedSprite2D
@onready var timer: Timer = $"../Timer"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	timer.start()

func animate():
	play("look")


func _on_timer_timeout() -> void:
	animate()
	timer.start()
