extends Control

## DEBUG SLOP

func _ready():
	pass

func _on_connect_pressed() -> void:
	NetworkHandler.start_client()
	get_tree().change_scene_to_file("res://gameplay/main_game.tscn")

func _on_host_pressed() -> void:
	NetworkHandler.start_server()
	get_tree().change_scene_to_file("res://gameplay/main_game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
