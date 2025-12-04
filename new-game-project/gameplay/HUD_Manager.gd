extends CanvasLayer

@onready var kill_text: Label = $Kills
@onready var timer_text: Label = $Timer

func _process(_delta):
	# Updates the timer
	var time_left = int(WinCondition.current_time)
	timer_text.text = "Time Left: " + str(time_left)
	
	# Updates the kills score
	kill_text.text = "Kills: " + str(WinCondition.kill_count)
	
	if WinCondition.game_active == false:
		timer_text.text = "GAME OVER"
