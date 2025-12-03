extends Node2D
##sets authority

@onready var controller = $CharacterBody2D
@onready var light = $CharacterBody2D/PointLight2D

func _enter_tree() -> void:
	print("new player id: ", name)
	set_multiplayer_authority(name.to_int(), true)

func _ready() -> void:
	if is_multiplayer_authority():
		print(name, " is authority!")
		light.visible = true
	else:
		print(multiplayer.get_unique_id(), " is not authority for ", get_multiplayer_authority())
