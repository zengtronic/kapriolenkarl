extends Node

var Player = preload("res://scenes/game/player/Player.tscn")
var Level = preload("res://scenes/game/Level/Level.tscn")

var players = []
var level = null
var running = false


remotesync func start_game(player_info):
	if running: return
	var lobby = get_node("../main/lobby")
	if lobby:
		lobby.get_node("background").hide()
		lobby.hide()
	var test = get_tree().get_root()
	if level:
		remove_child(level)
	
	for p in players:
		remove_child(p)
		p.queue_free()

	level = Level.instance()
	add_child(level)
	spawn(player_info)
	running = true


func spawn(player_info):
	var spawns = level.get_node("Spawns")
	var spawn_curve = spawns.get_curve()
	var step_size = 4.0 / float(len(player_info))
	var i = 0.0
	for info in player_info:
		var p = Player.instance()
		players.append(p)
		add_child(p)
		p.init(info)
		var sample_point = spawn_curve.interpolatef(i)
		p.translate(sample_point)
		p.look_at(Vector3(0, 0, 0), Vector3(0, 1, 0))
		i += step_size
