extends MultiplayerSpawner

@export var network_player: PackedScene
@onready var prey_spawn = $PreySpawn
@onready var pred_spawn = $PredSpawn


var pred_players: int = 0
var prey_players: int = 0

var scenes = [preload("res://gameplay/prey.tscn"), preload("res://gameplay/predator.tscn")]

signal player_spawned

func determine_team(id: int):
	print("spawning: ", id)
	if !multiplayer.is_server(): return
	
	if (id == 1):
		create_game_entry(id, scenes[0])
	else:
		create_game_entry(id, scenes[1])
	return
	if pred_players < prey_players:
		create_game_entry(id, scenes[1])
	elif prey_players < pred_players:
		create_game_entry(id, scenes[0])
	else:
		create_game_entry(id, scenes[randi_range(0,1)])

func create_game_entry(id: int, scene: PackedScene):
	"""if !multiplayer.is_server(): 
		print("not server")
		return
	else:
		print("server!")"""
	var player: Node = scene.instantiate()
	var location:Vector2
	
	player.name = str(id)
	player.position = location
	
	if (scene == scenes[0]):
		location = prey_spawn.global_position
		print("prey!")
		prey_players +=1
		get_node(spawn_path).call_deferred("add_child", player)
	else:
		location = pred_spawn.global_position
		print("pred!")
		get_node(spawn_path).call_deferred("add_child", player)
		pred_players += 1
	print("player spawned")
	player_spawned.emit(player)
