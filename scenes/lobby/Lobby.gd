extends Control

var port = 1080

var peer = null

var players = []

export(NodePath) var name_field
export(NodePath) var address_field
export(NodePath) var player_list

func _ready():
	var args = OS.get_cmdline_args()
	for arg in args:
		if "port" in arg:
			port = int(arg.split("=")[1])

	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")


sync func update_players(p):
	players = p
	get_node(player_list).clear()
	for player in players:
		if player.ready:
			get_node(player_list).add_item(player.name + " (Bereitschaft)")
		else:
			get_node(player_list).add_item(player.name)


func _player_connected(id):
	pass
	

master func register_player(name):
	var sender = get_tree().get_rpc_sender_id()
	for p in players:
		if p.name == name:
			return # no duplicate players
	players.append({
		"id": sender,
		"name": name,
		"ready": false
	})
	for p in players:
		rpc_id(p.id, "update_players", players)
	update_players(players)


master func player_ready(state):
	var sender = get_tree().get_rpc_sender_id()
	for p in players:
		if p.id == sender:
			p.ready = state
	var all_ready = true
	for p in players:
		rpc_id(p.id, "update_players", players)
		if !p.ready:
			all_ready = false
	update_players(players)
	if all_ready:
		print("staring game")
		GameManager.rpc("start_game", players)


func _player_disconnected(id):
	if not get_tree().is_network_server():
		return
	var p = null
	for player in players:
		if player.id == id:
			p = player
	if (!p):
		print("Couldn't find player to remove")
		return
	players.erase(p)
	for player in players:
		rpc_id(player.id, "update_players", players)
	update_players(players)


func _close_network():	
	if get_tree().is_connected("connection_failed", self, "_close_network"):
		get_tree().disconnect("connection_failed", self, "_close_network")
	if get_tree().is_connected("connected_to_server", self, "_connected"):
		get_tree().disconnect("connected_to_server", self, "_connected")
	if (peer):
		peer.disconnect_from_host()
	get_tree().set_network_peer(null)
	peer = null
	get_node(player_list).clear()
	print("Disconnected")


func _connected():
	if get_tree().is_network_server():
		return
	# register to the server with the name
	rpc_id(1, "register_player", get_node(name_field).text)


func _on_connect_pressed():
	if peer and get_tree().is_network_server():
		print("Server connecting to self")
		rpc("register_player", get_node(name_field).text)
		return
		rpc("register_player", "Dummy 1")
		rpc("register_player", "Dummy 2")
		rpc("register_player", "Dummy 3")
		rpc("register_player", "Dummy 4")
	# players will open a socket connection
	if peer:
		_close_network()
	var host = get_node(address_field).text
	peer = WebSocketClient.new()
	get_tree().connect("connection_failed", self, "_close_network")
	get_tree().connect("connected_to_server", self, "_connected")
	peer.connect_to_url("ws://" + host, PoolStringArray(), true)
	get_tree().set_network_peer(peer)


func _on_ready_pressed():
	var s = get_self()
	if (!s):
		return
	rpc("player_ready", !s.ready)


func get_self():
	var own = get_tree().get_network_unique_id()
	if (!own):
		return null
	for i in players:
		if i.id == own:
			return i
	return null


func _on_host_pressed():
	print("Starting server")
	peer = WebSocketServer.new()
	var e = peer.listen(port, PoolStringArray(), true)
	if (e == OK):
		get_tree().set_network_peer(peer)
		print("Server started on port " + str(port))
	else:
		printerr("Error starting server on " + str(port))
