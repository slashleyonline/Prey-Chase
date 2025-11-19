extends CharacterBody2D

const SPEED = 4000

func _process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	velocity = input * SPEED
	move_and_slide()

# wassup
