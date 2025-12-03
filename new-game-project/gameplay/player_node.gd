extends Node2D
##sets authority

@onready var controller = $CharacterBody2D
@onready var light = $CharacterBody2D/PointLight2D

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	controller.set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		light.visible = true
