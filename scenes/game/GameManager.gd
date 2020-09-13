extends Node

var Player = preload("res://scenes/game/player/Player.tscn")
var Level = preload("res://scenes/game/Level/Level.tscn")

var players = []
var level = null
var running = false
var debug = false


remotesync func start_game(player_info):
	if running: return
	end_game()
	running = true
	show_lobby(false)
	level = Level.instance()
	add_child(level)
	spawn(player_info)
	
	
remotesync func end_game():
	if level:
		remove_child(level)
		level.queue_free()
	
	for p in players:
		remove_child(p)
		p.queue_free()
	players = []
	if !running: return
	running = false
	show_lobby(true)


func show_lobby(show: bool):
	var lobby = get_node("../main/lobby")
	if lobby:
		lobby.get_node("background").visible = show
		lobby.visible = show
	

func spawn(player_info):
	var spawns = level.get_node("Spawns")
	var spawn_curve = spawns.get_curve()
	var step_size = 4.0 / float(len(player_info))
	var i = 0.0
	for info in player_info:
		info["is_local"] = get_tree().get_network_unique_id() == info.id
		var p = Player.instance()
		players.append(p)
		add_child(p)
		p.init(info)
		var sample_point = spawn_curve.interpolatef(i)
		p.translate(sample_point)
		p.look_at(Vector3(0, 0, 0), Vector3(0, 1, 0))
		i += step_size

func _input(event):
	if event.is_action("ui_cancel"):
		get_tree().quit()
