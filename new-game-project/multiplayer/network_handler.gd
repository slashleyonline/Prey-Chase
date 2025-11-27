extends Node2D

var ip_address = 'localhost'
var port: int = 2012
var peer: ENetMultiplayerPeer
var server_running = false

func start_server():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer

func start_client():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address,port)
	multiplayer.multiplayer_peer = peer
