extends CharacterBody2D

@export var speed = 300
@export var disguise_duration = 5.0
@onready var sprite = $Sprite2D
@onready var raycast = $RayCast2D
@onready var collision_shape = $CollisionShape2D

var original_texture = null
var is_disguised = false
var original_color = Color.WHITE
var original_scale = Vector2.ONE
var original_shape = null
var original_collision_transform = Transform2D.IDENTITY

# Variable to remember where to respawn
var spawn_position = Vector2.ZERO

# This is to remember what and where the prey started out as
func _ready():
	# Stores the location where the player spawned in the level
	spawn_position = global_position
	
	original_texture = sprite.texture
	original_color = sprite.modulate
	original_scale = sprite.scale
	
	if collision_shape.shape:
		original_shape = collision_shape.shape.duplicate()
	original_collision_transform = collision_shape.transform

func _physics_process(_delta: float) -> void:
	# Basic Movement
	var input = Input.get_vector("prey_left", "prey_right", "prey_up", "prey_down")
	velocity = input * speed
	move_and_slide()
	
	# Rotation Logic
	if input != Vector2.ZERO:
		var move_angle = input.angle()
		raycast.rotation = move_angle
		sprite.rotation = move_angle
		collision_shape.rotation = move_angle
	
	# Attempts to mimic
	if Input.is_action_just_pressed("hide") and not is_disguised:
		attempt_mimic()

# Mimic logic
func attempt_mimic():
	if raycast.is_colliding():
		var object_hit = raycast.get_collider()
		
		# Checks for a node named "Sprite2D", "CollisionShape2D" and that it isn't a predator
		if object_hit.has_node("Sprite2D") and object_hit.has_node("CollisionShape2D") and not object_hit.is_in_group("predator"):
			var target_sprite = object_hit.get_node("Sprite2D")
			var target_collision = object_hit.get_node("CollisionShape2D")
			
			# Copies the Image, Color, Size, Hitbox and resets hitbox location to be positioned correctly
			sprite.texture = target_sprite.texture
			sprite.modulate = target_sprite.modulate
			sprite.scale = target_sprite.scale
			collision_shape.set_deferred("shape", target_collision.shape)
			collision_shape.set_deferred("transform", Transform2D.IDENTITY)
			
			is_disguised = true
			
			await get_tree().create_timer(disguise_duration).timeout
			if is_disguised:
				revert_disguise()

# Resets the prey back to normal
func revert_disguise():
	sprite.texture = original_texture
	sprite.modulate = original_color
	sprite.scale = original_scale
	collision_shape.set_deferred("shape", original_shape)
	collision_shape.set_deferred("transform", original_collision_transform)
	
	is_disguised = false
	print("Mimic turned off")

# Death/Respawn logic
func die():
	print("The prey has been eaten!")
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Visual feedback for hit
	sprite.modulate = Color.RED
	
	# Waits a moment so the player realizes they died
	await get_tree().create_timer(0.5).timeout
	
	# Resets prey to original form
	if is_disguised:
		revert_disguise()
	else:
		sprite.modulate = original_color
		
	# Teleports prey back to spawn position
	global_position = spawn_position
	
	# Re-enables collision so we can keep playing
	$CollisionShape2D.set_deferred("disabled", false)
	
	print("Prey Respawned")
	
