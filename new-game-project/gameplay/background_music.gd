extends AudioStreamPlayer2D

func _ready():
	play()

	# Check if already connected before connecting
	if not is_connected("finished", Callable(self, "_on_finished")):
		connect("finished", Callable(self, "_on_finished"))

func _on_finished():
	play()  # restart the music
