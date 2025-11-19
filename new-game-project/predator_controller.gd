extends CharacterBody2D

const SPEED = 400

func _process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	if (input):
		print("wow")
	velocity = input * SPEED
	move_and_slide()
