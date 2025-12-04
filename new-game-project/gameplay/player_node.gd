extends Node2D
##sets authority

@onready var controller = $CharacterBody2D
@onready var light = $CharacterBody2D/PointLight2D
@onready var camera = $CharacterBody2D/Camera2D

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int(), true)

func _ready() -> void:
	if is_multiplayer_authority():
		light.visible = true
		camera.make_current()
