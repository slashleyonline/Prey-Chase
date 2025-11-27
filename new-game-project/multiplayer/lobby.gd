extends Control

@onready var container = $PlayerList/VBoxContainer
@export var game_started = false:
	set(input):
		if input == true:
			game_begin.emit()
			print("starting game!")

signal game_begin

func _ready():
	if (multiplayer.is_server()):
		var start = $Button
		start.visible = true

func check_container():
	var count = 0
	for i in container.get_children():
		if i.ready_play == true:
			count += 1
	var total = container.get_children().size()
	
	if count == total && (count <= 2):
		return true
	else: 
		return false


func _on_button_pressed() -> void:
	print("button pressed!")
	if (check_container()):
		game_started = true
	else:
		print("false!")
