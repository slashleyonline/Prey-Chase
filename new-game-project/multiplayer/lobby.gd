extends Control

@onready var container = $PlayerList/VBoxContainer

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

func start_game():
	pass

func _on_button_pressed() -> void:
	if (check_container()):
		start_game()
