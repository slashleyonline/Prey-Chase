extends Node2D

@onready var spawner = $BasicLevel/MultiplayerSpawner

func _enter_tree() -> void:
	set_multiplayer_authority(1)

func _on_lobby_game_begin() -> void:
	WinCondition.rpc("start_game")
	var game_lobby = $Lobby
	var game_main = $BasicLevel
	game_lobby.visible = false
	game_main.visible = true
	var final_peers_list = multiplayer.get_peers()
	final_peers_list.append(1)
	print(final_peers_list)
	spawn_all_players(final_peers_list)

func spawn_all_players(array: PackedInt32Array):
	for i in range(array.size()):
		var value = array[i]
		spawner.determine_team(value)

@rpc("any_peer", "call_local")
func apply_damage(prey_id):
	print("chungular")
	if !multiplayer.is_server(): return
	print(prey_id)
	var target = instance_from_id(prey_id)
	target.die()
