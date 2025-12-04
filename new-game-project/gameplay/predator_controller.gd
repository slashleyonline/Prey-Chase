extends CharacterBody2D

#editable in the editor
@export var speed = 400
@export var pounceSpeed = 1100
@export var pouncecDuration = 0.1
@export var pouncePauseTimer = 4.0
@export var attackCooldown = 1.5
@export var attackDuration = .25

#other important vars
var lookDirection = Vector2.RIGHT

#boolean vars
var is_pouncing = false
var can_pounce = true
var can_attack = true

#node refs
@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/HitboxShape

func _enter_tree() -> void:
	set_multiplayer_authority(get_parent().name.to_int(), true)
	get_parent().set_multiplayer_authority(get_parent().name.to_int(), true)
	global_position = Vector2(900,400)

	print("global pos: ", global_position)

func _physics_process(_delta: float) -> void:
	if !is_multiplayer_authority(): return
	
	# Stops movement if the game is over
	if WinCondition.game_active == false:
		return
		
	#checking for pounce
	if is_pouncing:
		move_and_slide()
		return
	
	#normal movement logic
	var input = Input.get_vector("pred_left", "pred_right", "pred_up", "pred_down")
	
	#direction logic
	if input != Vector2.ZERO:
		lookDirection = input
		hitbox.rotation = lookDirection.angle()
		#$PredatorWolf.rotation = lookDirection.angle()
	
	velocity = input * speed
	
	##inputs
	#pounce trigger
	if Input.is_action_just_pressed("pounce") and input != Vector2.ZERO and can_pounce:
		startPounce(input)
	#attack controls
	if Input.is_action_just_pressed("attack") and can_attack:
		performAttack()
		
	move_and_slide()

#pounce/dash function
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
	print("attack")
	can_attack = false
	hitbox_shape.disabled = false
	
	#attack duration
	await get_tree().create_timer(0.1).timeout
	
	#check what was hit
	var bodies = hitbox.get_overlapping_bodies()
	
	for body in bodies:
		print("found body")
		print(body.name)
		if body == self:
			continue
		if body.has_method("die"):
			print("prey found")
			if multiplayer.is_server():
				rpc("apply_damage", body.get_instance_id())
			else:
				print("client!")
				NetworkHandler.apply_damage.rpc(body.get_multiplayer_authority())
	await get_tree().create_timer(attackDuration).timeout
	hitbox_shape.disabled = true
	
	await get_tree().create_timer(attackCooldown).timeout
	can_attack = true

@rpc("any_peer", "call_local")
func apply_damage(prey_id):
	print("chungular pred! ", multiplayer.get_remote_sender_id())
	if !multiplayer.is_server(): return
	print(prey_id)
	var target = instance_from_id(prey_id)
	target.die()
