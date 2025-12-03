extends MultiplayerSpawner

@export var network_player: PackedScene

var pred_players: int = 0
var prey_players: int = 0

var scenes = [preload("res://gameplay/prey.tscn"), preload("res://gameplay/predator.tscn")]

signal player_spawned

func determine_team(id: int):
	create_game_entry(id, scenes[0])
	return
	
	if pred_players < prey_players:
		create_game_entry(id, scenes[1])
	elif prey_players < pred_players:
		create_game_entry(id, scenes[0])
	else:
		create_game_entry(id, scenes[randi_range(0,1)])

func create_game_entry(id: int, scene: PackedScene):
	print("created player entity!")	
	if !multiplayer.is_server(): 
		return
	var player: Node = scene.instantiate()
	if (scene == scenes[0]):
		prey_players +=1
	else:
		pred_players += 1
	
	player.name = str(id)
	print("player name: ", str(id))
	get_node(spawn_path).call_deferred("add_child", player)
	player_spawned.emit(player)
