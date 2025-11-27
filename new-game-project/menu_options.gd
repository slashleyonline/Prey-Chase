extends Control


func _on_connect_pressed() -> void:
	if (!NetworkHandler.server_running):
		NetworkHandler.start_server()
	else:
		print("joining")
		NetworkHandler.start_client()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
