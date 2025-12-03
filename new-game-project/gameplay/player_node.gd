extends Node2D
##sets authority

@onready var controller = $CharacterBody2D
@onready var light = $CharacterBody2D/PointLight2D

func _enter_tree() -> void:
	print("new player id: ", name)

func _ready() -> void:
	await get_tree().process_frame
	set_multiplayer_authority(name.to_int(), true)
	print("multiplayer authority: ", get_multiplayer_authority())
	if is_multiplayer_authority():
		print(name, " is authority!")
		light.visible = true
	else:
		print(name.to_int(), " is not authority for ", get_multiplayer_authority())
