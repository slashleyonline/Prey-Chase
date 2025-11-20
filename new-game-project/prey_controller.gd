extends CharacterBody2D

@export var speed = 300
@export var disguise_duration = 5.0
@onready var sprite = $Sprite2D
@onready var raycast = $RayCast2D

var original_texture = null
var is_disguised = false
var original_color = Color.WHITE
var original_scale = Vector2.ONE

# This is to remember what the prey started out as
func _ready():
	original_texture = sprite.texture
	original_color = sprite.modulate
	original_scale = sprite.scale

func _physics_process(_delta: float) -> void:
	# Basic Movement
	var input = Input.get_vector("left", "right", "up", "down")
	velocity = input * speed
	move_and_slide()
	
	# Rotates the RayCast and sprite so they always points the way we're moving.
	if input != Vector2.ZERO:
		raycast.rotation = input.angle()
		sprite.rotation = input.angle()

	# Attempts to mimic
	if Input.is_action_just_pressed("hide") and not is_disguised:
		attempt_mimic()

# Mimic logic
func attempt_mimic():
	if raycast.is_colliding():
		var object_hit = raycast.get_collider()
		print("Raycast hit: ", object_hit.name)
		
		# Checks for a node named "Sprite2D"
		if object_hit.has_node("Sprite2D"):
			print("Found Sprite2D on target!")
			var target_sprite = object_hit.get_node("Sprite2D")
			
			# 1. Copies the Image, Color, and Size
			sprite.texture = target_sprite.texture
			sprite.modulate = target_sprite.modulate
			sprite.scale = target_sprite.scale
			
			is_disguised = true
			
			await get_tree().create_timer(disguise_duration).timeout
			revert_disguise()

func revert_disguise():
	# Resets the prey back to normal
	sprite.texture = original_texture
	sprite.modulate = original_color
	sprite.scale = original_scale
	is_disguised = false
	print("Mimic turned off")

# Death logic for Prey by Predator
func die():
	print("The prey has been eaten!")
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Visual feedback for hit
	sprite.modulate = Color.RED
	
	# Deletes the prey for dying (will change later for a respawn function if that's what we want)
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
