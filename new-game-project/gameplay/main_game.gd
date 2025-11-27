extends Node2D


func _on_lobby_game_begin() -> void:
	var game_lobby = $Lobby
	var game_main = $BasicLevel
	game_lobby.visible = false
	game_main.visible = true
