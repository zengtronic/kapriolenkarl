extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var server
var port = 1080


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Starting server")
	server = WebSocketServer.new()
	var e = server.listen(port, PoolStringArray(), true)
	if (e == OK):
		get_tree().set_network_peer(server)
		print("Server started on port " + str(port))
	else:
		printerr("Error starting server on " + str(port))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
