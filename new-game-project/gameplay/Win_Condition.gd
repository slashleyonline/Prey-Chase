extends Node

var time_limit = 100.0
var kills_needed_to_lose = 3

var current_time = 0.0
var kill_count = 0
var game_active = true

func _ready():
	current_time = time_limit
	kill_count = 0
	game_active = true
	print("Game Started. Time: " + str(time_limit))

func _process(delta):
	# If game is over, stop counting
	if not game_active:
		return

	# Count down timer
	current_time -= delta
	
	# Checks if Time ran out
	if current_time <= 0:
		game_over("Prey Wins! (Time Survived)")

func register_death():
	# If game is over, ignore deaths
	if not game_active:
		return
		
	kill_count += 1
	print("Kills: " + str(kill_count) + "/" + str(kills_needed_to_lose))
	
	# Check if kill limit was reached
	if kill_count >= kills_needed_to_lose:
		game_over("Predator Wins! (Prey died too much)")

func game_over(winner_message):
	game_active = false
	print("GAME OVER: " + winner_message)
	
