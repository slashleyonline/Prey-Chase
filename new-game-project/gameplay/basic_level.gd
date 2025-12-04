extends Node2D

func spawn_player(player: Node, position):
	add_child(player)
	player.global_position = position
