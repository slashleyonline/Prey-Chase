extends Node2D

var ip_address = 'localhost'
var port: int = 2012
var peer: ENetMultiplayerPeer
var server_running = false

func _enter_tree() -> void:
	set_multiplayer_authority(1)

func start_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer

func start_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address,port)
	multiplayer.multiplayer_peer = peer

@rpc("any_peer", "call_local")
func apply_damage(prey_id):
	print("net! ", multiplayer.get_remote_sender_id())
	print("multiplayer id: ", prey_id)
	var target = get_node(str("/root/MainGame/BasicLevel/" + str(prey_id) + "/CharacterBody2D"))
	target.activate_death.rpc(str(prey_id))
	print("target's name is ", target.name)

@rpc("reliable", "any_peer")
func activate_death(name):
	print(self.name, " - ", name)
	if self.name == name:
		print("DIEEEE")
		var node = self
		if node.has_method("die"):
			node.die()
