extends MultiplayerSpawner

@export var network_player: PackedScene

signal player_spawned

func _ready():
	multiplayer.peer_connected.connect(create_game_entry)
	if multiplayer.is_server():
		create_game_entry(1) 

func create_game_entry(id: int):
	print("created player entity!")
	if !multiplayer.is_server(): 
		return
	var player: Node = network_player.instantiate()
	player.name = str(id)
	print("player name: ", str(id))
	get_node(spawn_path).call_deferred("add_child", player)
	player_spawned.emit(player)
