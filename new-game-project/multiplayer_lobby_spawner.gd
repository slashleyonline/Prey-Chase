extends MultiplayerSpawner

@export var network_player: PackedScene

func _ready():
	multiplayer.peer_connected.connect(create_lobby_entry)
	

func create_lobby_entry(id: int):
	if !multiplayer.is_server(): 
		return
	
	var player: Node = network_player.instantiate()
	player.name = str(id)
	
	get_node(spawn_path).call_deferred("add_child", player)
