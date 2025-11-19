extends CharacterBody2D

#editable in the editor
@export var speed = 400
@export var pounceSpeed = 1600
@export var pouncecDuration = 0.3
@export var pouncePauseTimer = 5.0
@export var attackCooldown = 1.5

#other important vars
var lookDirection = Vector2.RIGHT

#boolean vars
var is_pouncing = false
var can_pounce = true
var can_attack = true

#node refs
@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/HitboxShape

func _physics_process(_delta: float) -> void:
	#checking for pounce
	if is_pouncing:
		move_and_slide()
		return
	
	#normal movement logic
	var input = Input.get_vector("left", "right", "up", "down")
	
	#direction logic
	if input != Vector2.ZERO:
		lookDirection = input
		hitbox.rotation = lookDirection.angle()
		$Sprite2D.rotation = lookDirection.angle()
	
	velocity = input * speed
	
	##inputs
	#pounce trigger
	if Input.is_action_just_pressed("pounce") and input != Vector2.ZERO and can_pounce:
		startPounce(input)
	#attack controls
	if Input.is_action_just_pressed("attack") and can_attack:
		performAttack()
		
	move_and_slide()

#pounce function
func startPounce(direction: Vector2):
	is_pouncing = true
	can_pounce = false
	velocity = direction * pounceSpeed
	
	#setting an await so the player has to commit to the pounce and cannot control pred
	await get_tree().create_timer(pouncecDuration).timeout
	
	#ending the pounce
	is_pouncing = false
	
	#now wait out the cooldown
	var remainingCooldown = pouncePauseTimer - pouncecDuration
	await get_tree().create_timer(remainingCooldown).timeout
	
	can_pounce = true
	print("can pounce")
	

#attack logic
func performAttack():
	can_attack = false
	hitbox_shape.disabled = false
	
	#attack duration
	await get_tree().create_timer(0.1).timeout
	
	#check what was hit
	var bodies = hitbox.get_overlapping_bodies()
	
	for body in bodies:
		if body == self:
			continue
		if body.has_method("die"):
			body.die()
			
	hitbox_shape.disabled = true
	
	await get_tree().create_timer(attackCooldown).timeout
	can_attack = true
	
	
	
	
	
	
	
	
	
	
	
	
